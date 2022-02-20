extension DurationExt on Duration {
  String _twoDigits(int n) => n.toString().padLeft(2, "0");

  String get withFormat {
    String twoDigitMinutes = _twoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = _twoDigits(inSeconds.remainder(60));

    return inSeconds < Duration.minutesPerHour
        ? '$twoDigitMinutes:$twoDigitSeconds'
        : '${_twoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }
}
