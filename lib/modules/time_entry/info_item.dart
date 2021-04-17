import 'package:flutter/material.dart';

class InfoItem extends StatelessWidget {
  const InfoItem({
    Key key,
    this.label,
    this.value,
  }) : super(key: key);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 10),
        Text(
          label,
          style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),
        ),
        const SizedBox(width: 10),
        Text(
          value,
          style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),
        )
      ],
    );
  }
}
