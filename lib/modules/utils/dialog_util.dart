import 'package:flutter/material.dart';

class DialogUtil {
  static void showErrorMessage(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('Erro'),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                )
              ],
            ));
  }
}
