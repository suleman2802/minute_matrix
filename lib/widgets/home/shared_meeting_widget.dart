import 'package:flutter/material.dart';

import '../general/list_tile_widget.dart';
import '../../Screens/view_meeting_list_screen.dart';

class SharedMeetingWidget extends StatelessWidget {
  const SharedMeetingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
      child: SizedBox(
        width: double.infinity,
        //height: MediaQuery.of(context).size.height * 0.41,
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          elevation: 5,
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      " Shared Meetings",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context)
                          .pushNamed(ViewMeetingListScreen.routeName),
                      child: Text(
                        "View All",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                ListTileWidget("Suleman", "50:28","15/5/1212","","",""),
                ListTileWidget("Suleman", "50:28","15/5/1212","","",""),
                ListTileWidget("Suleman", "50:28","15/5/1212","","",""),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
