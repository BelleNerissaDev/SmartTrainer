List<DateTime> generateDateList(
    DateTime startDate, List<DateTime> excludeDates) {
  List<DateTime> dateList = [];
  DateTime currentDate = startDate;

  while (currentDate.isBefore(DateTime.now()) ||
      currentDate.isAtSameMomentAs(DateTime.now())) {
    if (!excludeDates.contains(currentDate)) {
      dateList.add(currentDate);
    }
    currentDate = currentDate.add(const Duration(days: 1));
  }

  return dateList;
}
