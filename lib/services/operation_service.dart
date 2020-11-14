import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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

Map<String, String> showDate(Timestamp date, DateTime currentDate) {
  DateTime serverDate = date.toDate();
  int differenceDay = currentDate.difference(serverDate).inDays;

  var formatterDate = DateFormat.yMd();
  var formatterClock = DateFormat.Hm();

  Map<String, String> dates = {
    'date': '',
    'clock': formatterClock.format(serverDate),
  };

  switch(differenceDay) {
    case(0):
      dates.update('date', (value) => 'Bugün');
      return dates;

    case(1):
      dates.update('date', (value) => 'Dün');
      return dates;

    default:
      dates.update('date', (value) => formatterDate.format(serverDate));
      return dates;

  }
}

String showDateComposedString(Timestamp date, DateTime currentDate) {
  Map<String, dynamic> dateMap = showDate(date, currentDate);
  return '${dateMap['date']} - ${dateMap['clock']}';
}