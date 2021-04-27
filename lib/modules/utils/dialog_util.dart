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

  static void showDialogWithActions(
      BuildContext context,
      String title,
      String message,
      String positiveText,
      VoidCallback positiveAction,
      String negativeText,
      VoidCallback negativeAction) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                  onPressed: positiveAction,
                  child: Text(positiveText),
                ),
                TextButton(
                  onPressed: negativeAction,
                  child: Text(negativeText),
                )
              ],
            ));
  }
}
