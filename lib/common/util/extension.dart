extension WeekdaySetExtension on Set<String> {
  List<String> toSortedWeekdays() {
    const List<String> orderedDays = [
      "MONDAY",
      "TUESDAY",
      "WEDNESDAY",
      "THURSDAY",
      "FRIDAY",
      "SATURDAY",
      "SUNDAY",
    ];

    final List<String> result = toList();
    result.sort((a, b) {
      return orderedDays.indexOf(a).compareTo(orderedDays.indexOf(b));
    });

    return result;
  }
}
