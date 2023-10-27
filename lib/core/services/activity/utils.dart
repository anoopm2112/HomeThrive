DateTime startOfDayUTC(DateTime date) {
  final utcDate = date.toUtc();
  return DateTime.utc(utcDate.year, utcDate.month, utcDate.day);
}
