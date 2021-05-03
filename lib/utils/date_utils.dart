import 'package:intl/intl.dart';

enum MyDateFormat {
  format1, // yyyy/MM/dd
  format2, // HH:mm:ss
  format3, // yyyy/MM/dd HH:mm:ss
  format4, // MMM dd, yyyy
  format5 // EEEE, HH:mm aa
}

class DateUtils {

  static String dateToString(DateTime date, bool convertToUtc, MyDateFormat dateFormat) {
    try {
      DateFormat _dateFormat = DateFormat(DateUtils.dateFormatToString(dateFormat));
      if (convertToUtc) {
        DateTime utcDate = date.toUtc();
        return _dateFormat.format(utcDate);
      } else {
        if (date.isUtc) {
          DateTime localDate = date.toLocal();
          return _dateFormat.format(localDate);
        } else {
          return _dateFormat.format(date);
        }
      }
    } catch (e) {
      print(e.toString());
      return '';
    }
  }

  static DateTime stringToDate(String dateStr, bool convertToLocal, MyDateFormat dateFormat) {
    try {
      DateFormat _dateFormat = DateFormat(DateUtils.dateFormatToString(dateFormat));
      DateTime date = _dateFormat.parse(dateStr);
      int timestamp = date.millisecondsSinceEpoch;
      if (convertToLocal) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp + DateTime.now().timeZoneOffset.inMilliseconds);
      } else {
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
    } catch (e) {
      print(e.toString());
      return DateTime(0);
    }
  }

  static String dateFormatToString(MyDateFormat format) {
    switch (format) {
      case MyDateFormat.format1:
        return 'yyyy/MM/dd';
      case MyDateFormat.format2:
        return 'HH:mm:ss';
      case MyDateFormat.format3:
        return 'yyyy/MM/dd HH:mm:ss';
      case MyDateFormat.format4:
        return 'MMM dd, yyyy';
      case MyDateFormat.format5:
        return 'EEEE, HH:mm aa';
      default:
        return '';
    }
  }
}