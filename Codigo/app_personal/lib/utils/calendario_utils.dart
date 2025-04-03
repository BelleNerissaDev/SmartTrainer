DateTime normalizeDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

List<DateTime> generateDateList(
    DateTime startDate, List<DateTime> excludeDates) {
  List<DateTime> dateList = [];
  DateTime currentDate = normalizeDate(startDate);
  DateTime now = normalizeDate(DateTime.now());

  // Normalize todas as datas de exclusão
  List<DateTime> normalizedExcludeDates =
      excludeDates.map((date) => normalizeDate(date)).toList();

  while (currentDate.isBefore(now) || currentDate.isAtSameMomentAs(now)) {
    if (!normalizedExcludeDates.any((excludeDate) =>
        excludeDate.year == currentDate.year &&
        excludeDate.month == currentDate.month &&
        excludeDate.day == currentDate.day)) {
      dateList.add(currentDate);
    }
    currentDate = currentDate.add(const Duration(days: 1));
  }

  return dateList;
}
