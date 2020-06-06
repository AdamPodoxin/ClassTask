import 'package:flutter/material.dart';

import '../Classes/class.dart';
import '../Classes/utility.dart';

class ClassWidget extends StatelessWidget {
  final Key key;
  final Class myClass;
  final GestureTapCallback onTapFunction;

  ClassWidget({
    this.key,
    this.myClass,
    this.onTapFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: this.key,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: ListTile(
        title: Text(
          myClass.name,
          textAlign: TextAlign.center,
        ),
        subtitle: Text(
          "${formatTimeOfDay(myClass.startTime)} - ${formatTimeOfDay(myClass.endTime)}",
          textAlign: TextAlign.center,
        ),
        onTap: onTapFunction,
      ),
    );
    //);
  }
}
