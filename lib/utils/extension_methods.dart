import 'package:intl/intl.dart';

extension DatetimeExtension on DateTime {
  DateTime onlyDate() {
    return DateTime(year, month, day);
  }

  String toOnlyDateString() {
    return '$year-$month-$day';
  }

  String toStatisticString() {
    return '${day.toStringLeadingTwoZero()}/${month.toStringLeadingTwoZero()}/$year';
  }
}

extension IntegerExtension on int {
  String toStringLeadingTwoZero() {
    return toString().padLeft(2, '0');
  }

  String toAppPrice() {
    var f = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return f.format(this);
  }
}
