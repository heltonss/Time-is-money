import 'package:flutter/material.dart';

class FingerPrintButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;

  // ignore: sort_constructors_first
  const FingerPrintButton({
    @required this.onPressed,
    @required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      height: 80.0,
      width: 80.0,
      child: FittedBox(
          child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: backgroundColor,
        child: const Icon(Icons.fingerprint),
      )),
    );
  }
}
