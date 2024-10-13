import 'package:flutter/material.dart';
import 'package:minute_matrix/Screens/record_offline_meeting_screen.dart';
import '../../Screens/record_online_meeting.dart';
import '../general/single_item.dart';

class RecordMeetingWidget extends StatelessWidget {
  const RecordMeetingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        //height: MediaQuery.of(context).size.height * 0.27,
        child: Center(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            color: Theme.of(context).cardColor,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Record New Meeting",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleItem(Icons.meeting_room, "Record Meeting"),
                      ),
                      onTap: () => Navigator.of(context)
                          .pushNamed(RecordOfflineMeetingScreen.routeName),
                    ),
                    const Divider(),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleItem(
                            Icons.cloud_upload, "Upload Meeting Recording"),
                      ),
                      onTap: () => Navigator.of(context)
                          .pushNamed(RecordOnlineMeetingScreen.routeName),
                    ),
                    //Divider(),

                    // OutlinedButton.icon(
                    //   style: OutlinedButton.styleFrom(
                    //       minimumSize: Size(double.infinity, 50)),
                    //   icon: Icon(Icons.meeting_room),
                    //   onPressed: () {},
                    //   label: Align(
                    //     alignment: Alignment.centerLeft,
                    //     child: Text(
                    //       "Record Online Meeting",
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 5,
                    // ),
                    // OutlinedButton.icon(
                    //   style: OutlinedButton.styleFrom(
                    //     minimumSize: Size(double.infinity, 50),
                    //   ),
                    //   icon: Icon(Icons.compass_calibration_rounded),
                    //   onPressed: () {},
                    //   label: Align(
                    //     alignment: Alignment.centerLeft,
                    //     child: Text(
                    //       "Record Online Meeting",
                    //     ),
                    //   ),
                    // ),
                    // OutlinedButton(
                    //   onPressed: () {},
                    //   child: ButtonStyleWidget("View All Meeting"),
                    // ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
