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
  DateTime serverDate = date != null ? date.toDate() : DateTime.now();

  int differenceDay =
  currentDate.year == serverDate.year
      ? currentDate.month == serverDate.month
        ? currentDate.day - serverDate.day
        : -1
      : -1;

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

bool calculateDateDifference(Timestamp firstDate, Timestamp secondDate) {
  DateTime dateOne = firstDate != null ?  firstDate.toDate() : DateTime.now();
  DateTime dateTwo = secondDate != null ?  secondDate.toDate() : DateTime.now();

  int differenceDay = dateOne.day - dateTwo.day;
  bool sameMonth = dateOne.month == dateTwo.month;
  bool sameYear = dateOne.year == dateTwo.year;

  if(sameYear)
    if(sameMonth)
      if(differenceDay < 1)
        return false;
      else
        return true;
    else
      return true;
  else
    return true;
}

String showDateOnly(Timestamp date) {
  Map<String, dynamic> dateMap = showDate(date);
  return '${dateMap['date']}';
}

String showDateComposedString(Timestamp date) {
  Map<String, dynamic> dateMap = showDate(date);

  if(dateMap['showClock'])
    return '${dateMap['date']} - ${dateMap['clock']}';
  else
    return '${dateMap['date']}';
}

String showDateComposedStringColumn(Timestamp date) {
  Map<String, dynamic> dateMap = showDate(date);

  if(dateMap['showClock'])
    return '${dateMap['date']}\n${dateMap['clock']}';
  else
    return '${dateMap['date']}';
}

String showClock(Timestamp date) {
  var formatter = DateFormat.Hm();
  var clock = formatter.format(date.toDate());
  return clock;
}

Future<Color> getDynamicColor(String imageUrl) async {
  PaletteGenerator palette = await PaletteGenerator.fromImageProvider(NetworkImage(imageUrl));
  Color color = palette.vibrantColor != null
      ? palette.vibrantColor.color
      : palette.lightVibrantColor != null
        ? palette.lightVibrantColor.color
        : palette.dominantColor != null
          ? palette.dominantColor.color
          : Colors.orange;

  return color;
}

// System.out.println(Arrays.toString("a;b;c;d".split("(?<=;)")));
// System.out.println(Arrays.toString("a;b;c;d".split("(?=;)")));
// System.out.println(Arrays.toString("a;b;c;d".split("((?<=;)|(?=;))")));

// [a;, b;, c;, d]
// [a, ;b, ;c, ;d]
// [a, ;, b, ;, c, ;, d]


// Keep seperator.
// Split işleminde emojileri ayırt ederken emojileri de array içinde tutar.
RegExp regexKeepEmoji = RegExp(r'((?<=(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff]))|(?=(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])))');

// Unkeep seperator.
// Split işleminde emojileri ayırt ederken emojileri arrayden siler.
// RegExp regexEmoji = RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');

// İnternetten bulunmuş url detector
// RegExp regexUrl = RegExp(r'(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})');

// Linkwell Regex
RegExp regexUrl = RegExp(r'((https?:www\.)|(https?:\/\/)|(www\.))?[\w/\-?=%.][-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?');
RegExp regexPhone = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');