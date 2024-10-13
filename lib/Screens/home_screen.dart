import 'package:flutter/material.dart';
import 'package:minute_matrix/Models/UserDetails.dart';
import 'package:minute_matrix/Models/latest_meeting.dart';
import 'package:minute_matrix/Providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/drawer/drawer_widget.dart';
import '../widgets/general/collaboration_widget.dart';
import '../widgets/home/join_offline_meeting_widget.dart';
import '../widgets/home/minute_consumed_widget.dart';
import '../widgets/home/recent_meeting_widget.dart';
import '../widgets/home/record_meeting_widget.dart';

// import '../widgets/home/shared_meeting_widget.dart';
import '../widgets/profile/profile_pic.dart';
import '../widgets/home/dropdown_widget.dart';
import '../widgets/chat/new_message.dart';
import '../widgets/chat/messages.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/HomeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isStandard = false;
  String subcribedPlan = "";
  String hostUid = "";
  List<LatestMeeting>? latestMeeting;

  getSubriptionPlanDetails() {
    UserDetails userDetails =
        Provider.of<UserProvider>(context, listen: false).userDetails;
    subcribedPlan = userDetails.getSubscription_plan();
    hostUid = userDetails.getId();
    if (subcribedPlan == "Standard") {
      isStandard = true;
    }
  }

  Future<List<LatestMeeting>> getLatestMeetings() async {
    latestMeeting = [];
    latestMeeting =
        await Provider.of<UserProvider>(context).fetchLatestMeetings();
    return latestMeeting!;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSubriptionPlanDetails();
    //getLatestMeetings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: const Text(
          "Dashboard",
        ),
        actions: [
          //dropdownWidget()
          ProfilePic(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            MinuteConsumedWidget(),
            RecordMeetingWidget(),
            JoinOfflineMeetingWidget(),
            isStandard
                ? SizedBox()
                : Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                    child: CollaborationWidget(hostUid, false),
                  ),
            FutureBuilder<List<LatestMeeting>>(
              future: getLatestMeetings(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                // if (snapshot.connectionState == ConnectionState.none) {
                //   return const CircularProgressIndicator();
                // }
                if (snapshot.hasError) {
                  return const Text("Unable to load latest meeting record");
                }
                if (snapshot.hasData) {
                  return RecentMeetingWidget(snapshot.data);
                } else {
                  return const Text("Add new meeting first");
                }
              },
            ),
            //SharedMeetingWidget(),
            //  Expanded(
            //   child: Messages(),
            //  ),
            // NewMessage(),
            // //Text("Dashboard"),
          ],
        ),
      ),
      //),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Icon(Icons.mic_rounded),
      // ),
    );
  }
}
