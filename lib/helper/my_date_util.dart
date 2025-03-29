import 'dart:developer';

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
    bool showYear = false,
  }) {
   
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));

    final DateTime now = DateTime.now();

    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }

    return showYear
        ? '${sent.day} ${getMonth(time: sent)} ${sent.year}'
        : '${sent.day} ${getMonth(time: sent)}';
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

  static getLastActiveTime({
    required BuildContext context,
    required String lasttime,
  }) {
    final int i = int.tryParse(lasttime) ?? -1;

    //if time is not availbale for
    if (i == 1) return 'Last Seen not available';
    DateTime lastActive = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();

    String formattedTime = TimeOfDay.fromDateTime(lastActive).format(context);

    if (lastActive.day == now.day &&
        lastActive.month == now.month &&
        lastActive.year == now.year) {
      return 'Last Seen Today at $formattedTime';
    }

    if (now.difference(lastActive).inHours / 24.round() == 1) {
      return 'Last Seen Yesterday at $formattedTime';
    }

    String month = getMonth(time: lastActive);
    return 'Last Seen on ${lastActive.day} $month at $formattedTime';
  }
}
