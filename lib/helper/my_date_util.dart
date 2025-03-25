import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/material.dart';

class MyDateUtil {
  static String getFormattedDate({
    required BuildContext context,
    required String time,
  }) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));

    log(TimeOfDay.fromDateTime(date).format(context));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  static String getLastMessageTime({
    required BuildContext context,
    required String time,
  }) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));

    final DateTime now = DateTime.now();

    log('now: $now');
    log('now: $sent');

    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }

    return '${sent.day} ${getMonth(time: sent)}';
  }

  static String getMonth({
    // required BuildContext context,
    required DateTime time,
  }) {
    switch (time.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
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
