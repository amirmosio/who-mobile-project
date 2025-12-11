import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';

extension DateTimeEndStartOfTheDay on DateTime {
  DateTime get endOfTheDay {
    return copyWith(hour: 23, minute: 59, second: 59);
  }

  DateTime get startOfTheDay {
    return DateTime(year, month, day);
  }
}

class DateTimeUtils {
  static const ddMMMyyyy = 'dd MMM yyyy';
  static const ddMMMMyyyy = 'dd MMMM yyyy';
  static const ddMMMyyyCommaHHMM = "dd MMM yyyy, HH:mm";
  static const ddMMMyyySpaceHHMM = "dd MMM yyyy HH:mm";
  static const ddSMMSyyyy = "dd/MM/yyyy";

  // ignore: constant_identifier_names
  static const dd_MMMM_yyyy = 'yyyy-MM-dd';
  static const yyNextLineMMM = "yy\nMMM";
  static const yyyyMMddHHmmssSSSSSS = "yyyy-MM-dd HH:mm:ss.SSSSSS";
  static const yyyyMMddTHHmmssSSSSSS = "yyyy-MM-ddTHH:mm:ss.SSSSSS";
  static const yyyyMMddTHHmmss = "yyyy-MM-ddTHH:mm:ss";
  static const yyyyMMddT000000 = "yyyy-MM-ddT00:00:00";
  static const yyyyMMddT235959 = "yyyy-MM-ddT23:59:59";

  DateTimeUtils._privateConstructor();

  static String dayByIndex(BuildContext context, int index) {
    switch (index) {
      case 0:
        return AppLocalizations.of(context)!.monday;
      case 1:
        return AppLocalizations.of(context)!.tuesday;
      case 2:
        return AppLocalizations.of(context)!.wednesday;
      case 3:
        return AppLocalizations.of(context)!.thursday;
      case 4:
        return AppLocalizations.of(context)!.friday;
      case 5:
        return AppLocalizations.of(context)!.saturday;
      case 6:
        return AppLocalizations.of(context)!.sunday;
      default:
        return "";
    }
  }

  static String dayStringIdByIndex(int index) {
    assert(index >= 0 && index <= 6, "Index must be between 0 and 6");
    switch (index) {
      case 0:
        return "monday";
      case 1:
        return "tuesday";
      case 2:
        return "wednesday";
      case 3:
        return "thursday";
      case 4:
        return "friday";
      case 5:
        return "saturday";
      case 6:
        return "sunday";
      default:
        return "";
    }
  }

  static convertDateTimeToTimeGapString(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}week';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '${months}month';
    } else {
      final years = (difference.inDays / 365).floor();
      final remainingMonths = ((difference.inDays % 365) / 30).floor();
      return '${years}y, ${remainingMonths}m';
    }
  }

  static int convertToTimestamp(DateTime datetime) {
    return datetime.millisecondsSinceEpoch ~/ 1000;
  }

  static String convertToFormatedDate(
    String dateString, {
    String dateFormatPattern = DateTimeUtils.ddMMMMyyyy,
    String inputDateFormat = DateTimeUtils.ddSMMSyyyy,
  }) {
    late DateTime dateTime;
    try {
      dateTime = DateTime.parse(dateString);
    } catch (e) {
      DateFormat format = DateFormat(
        inputDateFormat,
      ); // Define the input format
      dateTime = format.parse(dateString); //
    }

    return DateFormat(dateFormatPattern, 'en').format(dateTime);
  }

  static DateTime convertToDateTime(
    String dateString, {
    String inputDateFormat = DateTimeUtils.ddSMMSyyyy,
  }) {
    DateFormat format = DateFormat(inputDateFormat); // Define the input format
    return format.parse(dateString); //
  }

  static String getDefaultDateTimeForDatePicker() {
    DateTime now = DateTime.now();
    DateTime firstDayOfYear = DateTime(now.year, 1, 1);
    DateFormat formatter = DateFormat(ddMMMyyyy, 'en');
    return "${formatter.format(firstDayOfYear)} - ${formatter.format(now)}";
  }

  static DateTime convertTimestampStringToDateTime(String timestamp) {
    int milliseconds =
        int.parse(timestamp) * 1000; // from seconds to milliseconds
    return DateTime.fromMillisecondsSinceEpoch(milliseconds);
  }

  static String convertDateTimeToString(
    DateTime dateTime, {
    String dateFormatPattern = "d MMMM yyyy",
  }) {
    return DateFormat(dateFormatPattern, 'en').format(dateTime);
  }

  /// calendar stuff
  static DateTime getFirstDayOfTheMonth(DateTime date) {
    return date.copyWith(day: 1);
  }

  static DateTime getLastDayOfTheMonth(DateTime date) {
    final firstDayOfMonth = date.copyWith(day: 1);
    final month = firstDayOfMonth.month;
    final year = firstDayOfMonth.year;
    final int nextMonth = month < 12 ? month + 1 : 1;
    final int nextYear = month < 12 ? year : year + 1;
    final firstDayOfNextMonth = DateTime(nextYear, nextMonth, 1);
    return firstDayOfNextMonth.subtract(Duration(days: 1));
  }

  static DateTime getFirstDayOfTheWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  static DateTime getLastDayOfTheWeek(DateTime date) {
    return date.add(Duration(days: DateTime.daysPerWeek - date.weekday));
  }

  static DateTime today() {
    return DateTime.now();
  }

  static String convertHourMinuteToFormattedString(int hour, int minute) {
    final startHour = hour.toString().padLeft(2, '0');
    final startMinute = minute.toString().padLeft(2, '0');

    return "$startHour:$startMinute";
  }

  /// Get month abbreviation based on month number
  static String getMonthAbbreviation(BuildContext context, int month) {
    switch (month) {
      case 1:
        return "Jan";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "Apr";
      case 5:
        return "May";
      case 6:
        return "Jun";
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }
}
