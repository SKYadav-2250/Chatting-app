import 'package:flutter/material.dart';

class Dialogs {
  static void showSnackbar(BuildContext context, String msg, bool? dura) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: TextStyle(color: Colors.black)),
        backgroundColor: const Color.fromARGB(255, 106, 162, 209),
        duration: Duration(milliseconds: dura == true ? 800 : 3000),
      ),
    );
  }

  static void showProgressbar(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }
}
