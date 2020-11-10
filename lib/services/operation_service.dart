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