import 'package:flutter/material.dart';

class SingleItemUsageWidget extends StatelessWidget {
  int consumed;
  int total;
  String title;

  SingleItemUsageWidget(this.consumed, this.total, this.title);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                //color: Colors.black,
              ),
            ),
            Row(
              children: [
                Text(
                  "remains ",
                  style: TextStyle(fontSize: 14,//color: Colors.black,
                  ),
                ),
                Text(
                  consumed.toString(),
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w700),
                ),
                Text("/"),
                Text(
                  total.toString(),
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 12,fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 6,
        ),
        LinearProgressIndicator(
          minHeight: 11,
          borderRadius: BorderRadius.circular(4),
          backgroundColor: Theme.of(context).canvasColor,
          value: consumed/total,
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        ),
      ],
    );
  }
}
