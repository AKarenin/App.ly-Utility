class DateTimeUtil {
  List<DateTime> getMondayAndFriday(DateTime dateTime){
    int daysSinceMonday = dateTime.weekday - 1;
    final monday = dateTime.subtract(Duration(days: daysSinceMonday));
    final friday = monday.add(const Duration(days: 4));

    return [monday, friday];
  }
}