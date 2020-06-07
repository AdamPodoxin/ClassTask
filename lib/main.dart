import 'Widgets/classWidget.dart';
import 'Classes/class.dart';
import 'Classes/utility.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  TimeOfDay _selectedStartTime = TimeOfDay.now(),
      _selectedEndTime = TimeOfDay.now();

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

  Future<Null> setStartTime() async {
    TimeOfDay _time = TimeOfDay.now();
    _time = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    return _time;
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
            _selectedStartTime,
            _selectedEndTime,
          );

          if (index < 0) {
            createNewClass(editedClass);
          } else {
            editClass(index, editedClass);
          }

          setState(() {
            _editingClass = false;
          });

          saveClasses();

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
          setState(() {
            if (index >= 0) {
              classes.removeAt(index);
            }

            _editingClass = false;
          });

          saveClasses();

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

        _selectedStartTime = classes[index].startTime;
        _selectedEndTime = classes[index].endTime;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
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
                    FlatButton(
                      child: Text(formatTimeOfDay(_selectedStartTime)),
                      onPressed: () {
                        TimeOfDay _time = _selectedStartTime;
                        Future<Null> timePicker() async {
                          _time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );

                          if (_time == null) {
                            _time = _selectedStartTime;
                          }

                          setState(() {
                            _selectedStartTime = _time;
                          });
                        }

                        timePicker();
                      },
                    ),
                    SizedBox(width: 20),
                    Text("to"),
                    SizedBox(width: 20),
                    FlatButton(
                      child: Text(formatTimeOfDay(_selectedEndTime)),
                      onPressed: () {
                        TimeOfDay _time = _selectedEndTime;
                        Future<Null> timePicker() async {
                          _time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );

                          if (_time == null) {
                            _time = _selectedEndTime;
                          }

                          setState(() {
                            _selectedEndTime = _time;
                          });
                        }

                        timePicker();
                      },
                    ),
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

  void saveClasses() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> classNames = new List<String>(),
        classStartTimes = new List<String>(),
        classEndTimes = new List<String>();

    for (Class c in classes) {
      classNames.add(c.name);
      classStartTimes.add(formatTimeOfDay(c.startTime));
      classEndTimes.add(formatTimeOfDay(c.endTime));
    }

    prefs.setStringList("class_names", classNames);
    prefs.setStringList("class_start_times", classStartTimes);
    prefs.setStringList("class_end_times", classEndTimes);
  }

  void loadClasses() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> classNames = prefs.getStringList("class_names"),
        classStartTimes = prefs.getStringList("class_start_times"),
        classEndTimes = prefs.getStringList("class_end_times");

    List<Class> loadedClasses = new List<Class>();

    for (int i = 0; i < classNames.length; i++) {
      loadedClasses.add(new Class(
        classNames[i],
        getTimeOfDayFromFormattedString(classStartTimes[i]),
        getTimeOfDayFromFormattedString(classEndTimes[i]),
      ));
    }

    setState(() {
      classes = loadedClasses;
    });
  }

  @override
  void dispose() {
    _classNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    loadClasses();
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
