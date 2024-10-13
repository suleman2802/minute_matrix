import 'package:flutter/material.dart';

class SingleItem extends StatelessWidget {
  final _icon;
  final _title;
  SingleItem(this._icon, this._title);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Icon(_icon,color: Theme.of(context).primaryColor),
          const SizedBox(
            width: 10,
          ),
          Text(_title,style: Theme.of(context).textTheme.bodyMedium,),
        ],
      ),
    );
  }
}
