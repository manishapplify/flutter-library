String displayMessageTime(DateTime? time) {
  if (time == null) {
    return '';
  }

  final DateTime now = DateTime.now();
  if (now.difference(time).compareTo(const Duration(days: 1)) < 0 &&
      now.day == time.day) {
    return '${time.hour <= 12 ? time.hour : time.hour % 12}:${time.minute < 10 ? '0${time.minute}' : time.minute} ${time.hour > 11 ? 'PM' : 'AM'}';
  }

  // TODO: Also check if both the timestamps are in the same week.
  else if (now.difference(time).compareTo(const Duration(days: 7)) < 0) {
    return _mapDay[time.weekday]!;
  } else if (now.difference(time).compareTo(const Duration(days: 365)) < 0) {
    return '${time.day} ${_mapMonth[_mapMonth]}';
  } else {
    return time.year.toString();
  }
}

const Map<int, String> _mapDay = <int, String>{
  1: 'Mon',
  2: 'Tue',
  3: 'Wed',
  4: 'Thu',
  5: 'Fri',
  6: 'Sat',
  7: 'Sun',
};

const Map<int, String> _mapMonth = <int, String>{
  1: 'Jan',
  2: 'Feb',
  3: 'Mar',
  4: 'Apr',
  5: 'May',
  6: 'Jun',
  7: 'Jul',
  8: 'Aug',
  9: 'Sep',
  10: 'Oct',
  11: 'Nov',
  12: 'Dec',
};
