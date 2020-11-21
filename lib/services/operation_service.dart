import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:palette_generator/palette_generator.dart';

String calculateTimer(int time) {
  if (time < 60) {
    String secondStr = (time % 60).toString().padLeft(2, '0');
    return '00 : $secondStr';
  } else {
    int remainingSecond = time % 60;
    String secondStr = (remainingSecond % 60).toString().padLeft(2, '0');

    int minutes = (time / 60).truncate();
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');

    return '$minutesStr : $secondStr';
  }
}

Map<String, dynamic> showDate(Timestamp date) {
  DateTime currentDate = DateTime.now();
  DateTime serverDate = date != null ? date.toDate() : Timestamp(1,1).toDate();
  int differenceDay = currentDate.difference(serverDate).inDays;

  var formatterDate = DateFormat.yMd();
  var formatterClock = DateFormat.Hm();

  Map<String, dynamic> dates = {
    'date': '',
    'clock': formatterClock.format(serverDate),
    'showClock': false,
  };

  switch(differenceDay) {
    case(0):
      dates.update('date', (value) => 'Bugün');
      dates.update('showClock', (value) => true);
      return dates;

    case(1):
      dates.update('date', (value) => 'Dün');
      dates.update('showClock', (value) => true);
      return dates;

    default:
      dates.update('date', (value) => formatterDate.format(serverDate));
      return dates;

  }
}

String showDateComposedString(Timestamp date) {
  Map<String, dynamic> dateMap = showDate(date);

  if(dateMap['showClock'])
    return '${dateMap['date']} - ${dateMap['clock']}';
  else
    return '${dateMap['date']}';
}

Future<Color> getDynamicColor(String imageUrl) async {
  PaletteGenerator palette = await PaletteGenerator.fromImageProvider(NetworkImage(imageUrl));
  Color color = palette.vibrantColor != null ? palette.vibrantColor.color : palette.lightVibrantColor.color;

  return color;
}