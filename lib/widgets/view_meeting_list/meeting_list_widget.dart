import 'package:flutter/material.dart';

import '../general/list_tile_widget.dart';
import '../general/item_heading.dart';
class MeetingListWidget extends StatelessWidget {
  bool isOnline;
  MeetingListWidget(this.isOnline);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Expanded(
        child: Column(
          children: [
            ItemHeading(isOnline? "Online Recorded Meetings ":"Offline Recorded Meetings "),
            //ListView.builder(itemBuilder: (context, index) => ButtonStyleWidget(),itemCount: 4,)
          ListView( children: [
            //ListTileWidget(),
          ]),
          ],
        ),
      ),
    );
  }
}
