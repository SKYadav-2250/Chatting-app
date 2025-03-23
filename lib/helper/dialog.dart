import 'package:flutter/material.dart';

class Dialogs {
  static void showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,style: TextStyle(color:Colors.black),),
        backgroundColor: Colors.blue.withValues(alpha: 5),
      ),
    );
  }

  static void showProgressbar(BuildContext context) {
    showDialog(context: context, builder: (_) =>const Center(child: CircularProgressIndicator()));
  }
}
