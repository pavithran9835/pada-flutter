import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'app_provider.dart';
import 'auth_provider.dart';

List<SingleChildWidget> providers() {
  return [
    ChangeNotifierProvider(create: (_) => AppProvider()),
    ChangeNotifierProvider(create: (_) => AuthProvider())
  ];
}
List<DateTime>? getMonthView(DateTime? currentDate) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // calculate the current month and return in a list of date times from the currentDate
  if (currentDate == null) return null;

  final List<DateTime> monthView = [];

  final int year = currentDate.year;
  final int month = currentDate.month;

  final DateTime firstDayOfMonth = DateTime(year, month, 1);
  final int daysInMonth = DateTime(year, month + 1, 0).day;

  int weekdayOfFirstDay = firstDayOfMonth.weekday;
  if (weekdayOfFirstDay == 7) weekdayOfFirstDay = 0;

  for (int i = 0; i < weekdayOfFirstDay; i++) {
    monthView
        .add(firstDayOfMonth.subtract(Duration(days: weekdayOfFirstDay - i)));
  }

  for (int i = 1; i <= daysInMonth; i++) {
    monthView.add(DateTime(year, month, i));
  }

  int daysAdded = monthView.length;

  for (int i = 1; daysAdded % 7 != 0; i++) {
    monthView.add(DateTime(year, month + 1, i));
    daysAdded++;
  }

  return monthView;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
