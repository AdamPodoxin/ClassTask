import 'Widgets/classWidget.dart';
import 'Classes/class.dart';

import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        home: ClassTask(),
      ),
    );

class ClassTask extends StatefulWidget {
  @override
  ClassTaskState createState() => ClassTaskState();
}

class ClassTaskState extends State<ClassTask> {
  List<Class> classes = new List<Class>();

  BuildContext context;
  final _classNameController = TextEditingController();

  bool _editingClass = false;

  void createNewClass(Class newClass) {
    setState(() {
      classes.add(newClass);
    });
  }

  void editClass(int index, Class newClass) {
    setState(() {
      classes[index] = newClass;
    });
  }

  void listReordered(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final Class item = classes.removeAt(oldIndex);
      classes.insert(newIndex, item);
    });
  }

  void showEditClassDialog(int index) {
    if (!_editingClass) {
      setState(() {
        _editingClass = true;
      });

      final FlatButton doneButton = FlatButton(
        child: Icon(Icons.check, color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        color: Colors.green[400],
        padding: const EdgeInsets.all(16),
        onPressed: () {
          Class editedClass = new Class(
            _classNameController.text,
            new DateTime(2000),
            new DateTime(2000),
          );

          if (index < 0) {
            createNewClass(editedClass);
          } else {
            editClass(index, editedClass);
          }

          setState(() {
            _editingClass = false;
          });

          Navigator.of(this.context).pop();
        },
      );

      final FlatButton deleteButton = FlatButton(
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        color: Colors.red[400],
        padding: const EdgeInsets.all(16),
        onPressed: () {
          if (index >= 0) {
            setState(() {
              classes.removeAt(index);
            });
          }

          setState(() {
            _editingClass = false;
          });

          Navigator.of(this.context).pop();
        },
      );

      _classNameController.text = "";
      final TextField nameField = TextField(
        decoration: InputDecoration(labelText: 'Class name'),
        controller: _classNameController,
        keyboardType: TextInputType.visiblePassword,
      );

      if (index >= 0) {
        _classNameController.text = classes[index].name;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter stateSetter) {
            return SimpleDialog(
              contentPadding: const EdgeInsets.only(
                left: 50,
                right: 50,
                top: 30,
                bottom: 30,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
              title: Text(
                "Edit class",
                textAlign: TextAlign.center,
              ),
              children: [
                nameField,
                SizedBox(height: 12),
                Row(
                  children: [
                    deleteButton,
                    SizedBox(width: 40),
                    doneButton,
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    deleteButton,
                    SizedBox(width: 40),
                    doneButton,
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ],
            );
          });
        },
      );
    }
  }

  @override
  void dispose() {
    _classNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("ClassTask"),
            centerTitle: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(40),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showEditClassDialog(-1);
            },
            child: Icon(Icons.add),
          ),
          body: ReorderableListView(
            padding: const EdgeInsets.all(30),
            scrollDirection: Axis.vertical,
            children: List.generate(
              classes.length,
              (index) {
                return ClassWidget(
                  key: Key('$index'),
                  myClass: classes[index],
                  onTapFunction: () {
                    showEditClassDialog(index);
                  },
                );
              },
            ),
            onReorder: listReordered,
          ),
        ),
      ),
    );
  }
}
