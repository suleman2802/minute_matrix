import 'package:flutter/material.dart';

class ItemHeading extends StatelessWidget {
  final _title;
  ItemHeading(this._title);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      height: 50,
      color: Theme.of(context).cardColor,
      child: Text(
        _title,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }
}
