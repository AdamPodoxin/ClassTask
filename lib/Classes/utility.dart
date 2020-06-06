import 'package:flutter/material.dart';

String formatTimeOfDay(TimeOfDay timeOfDay) {
  String output = "";

  String hourStr = timeOfDay.hour.toString(),
      minuteStr = timeOfDay.minute.toString();

  if (hourStr.length == 1) {
    hourStr = "0" + hourStr;
  }
  if (minuteStr.length == 1) {
    minuteStr = "0" + minuteStr;
  }

  output = "$hourStr:$minuteStr";
  return output;
}
