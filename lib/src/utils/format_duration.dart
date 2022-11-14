String formatDuration(num timestampInSeconds) {
  var ms = (DateTime.now()).millisecondsSinceEpoch;
  var s = (ms / 1000).round();
  var d = Duration(seconds: s - timestampInSeconds.round());

  var seconds = d.inSeconds;
  final days = seconds ~/ Duration.secondsPerDay;
  seconds -= days * Duration.secondsPerDay;
  final hours = seconds ~/ Duration.secondsPerHour;
  seconds -= hours * Duration.secondsPerHour;
  final minutes = seconds ~/ Duration.secondsPerMinute;
  seconds -= minutes * Duration.secondsPerMinute;

  if (days != 0) {
    return '${days}d';
  }
  if (hours != 0) {
    return '${hours}h';
  }
  if (minutes != 0) {
    return '${minutes}m';
  }
  return '${seconds}s';
}
