import 'package:flutter/material.dart';

import '../../Models/latest_meeting.dart';
import '../general/list_tile_widget.dart';
import '../../Screens/view_meeting_list_screen.dart';

class RecentMeetingWidget extends StatelessWidget {
  List<LatestMeeting>? latestMeeting;

  RecentMeetingWidget(this.latestMeeting);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
      child: SizedBox(
        width: double.infinity,
        //height: MediaQuery.of(context).size.height * 0.41,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                      " Recent Meetings",
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
                latestMeeting!.length <= 0
                    ? const Text("Add Meeting first")
                    : Column(
                        children: latestMeeting!
                            .map(
                              (meeting) => ListTileWidget(
                                meeting.meetingName,
                                meeting.duration,
                                meeting.time,
                                meeting.type,
                                meeting.hostName,
                                meeting.hostId,
                              ),
                            )
                            .toList(),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
