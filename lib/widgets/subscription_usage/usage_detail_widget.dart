import 'package:flutter/material.dart';
import 'package:minute_matrix/Models/UserDetails.dart';
import 'package:minute_matrix/Providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../../Screens/subscription_plans_screen.dart';
import './single_item_usage_widget.dart';

class UsageDetailWidget extends StatefulWidget {
  @override
  State<UsageDetailWidget> createState() => _UsageDetailWidgetState();
}

class _UsageDetailWidgetState extends State<UsageDetailWidget> {
  bool isStandard = false;
  int totalNoOfOffline = 0;
  int totalNoOfUploads = 0;
  int totalNoOfMeetingCredits = 0;
  int totalNoOfMeetingHours = 0;
  int consumedNoOfOffline = 0;
  int consumedNoOfUploads = 0;
  int consumedNoOfMeetingCredits = 0;
  int consumedNoOfMeetingHours = 0;

  getSubcriptionPlanDetails() {
    UserDetails userDetails =
        Provider.of<UserProvider>(context, listen: false).userDetails;
    String subcribedPlan = userDetails.getSubscription_plan();
    totalNoOfOffline =  userDetails.getNo_offline_total();
    totalNoOfUploads = userDetails.getNo_upload_total();
    totalNoOfMeetingCredits = userDetails.getTotal_meeting_credit();
    totalNoOfMeetingHours = userDetails.getTotal_meeting_hours();
    consumedNoOfOffline = userDetails.getNo_offline_consumed();
    consumedNoOfUploads = userDetails.getNo_upload_consumed();
    consumedNoOfMeetingCredits = userDetails.getMeeting_credit_consumed().toInt();
    consumedNoOfMeetingHours = userDetails.getMeeting_hours_consumed().toInt();
    if (subcribedPlan == "Standard") {
      isStandard = true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSubcriptionPlanDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      //height: 50,
      margin: const EdgeInsets.all(5),
      //decoration: BoxDecoration(
      // borderRadius: BorderRadius.circular(12), color: Theme.of(context).cardColor),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Usage Details",
                  style: TextStyle(
                    //color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton(
                  onPressed: () => isStandard
                      ? Navigator.of(context)
                          .pushNamed(SubscriptionPlansScreen.routeName)
                      : null,
                  child: Text(
                    isStandard ? "Upgrade Plan" : "Enterprise Plan",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SingleItemUsageWidget(consumedNoOfMeetingCredits, totalNoOfMeetingCredits, "Meeting Credits"),
            const SizedBox(
              height: 8,
            ),
            SingleItemUsageWidget(consumedNoOfMeetingHours, totalNoOfMeetingHours, "Meeting Hours"),
            const SizedBox(
              height: 8,
            ),
            SingleItemUsageWidget(consumedNoOfOffline, totalNoOfOffline, "No. offline Meetings"),
            const SizedBox(
              height: 8,
            ),
            SingleItemUsageWidget(consumedNoOfUploads, totalNoOfUploads, "No. online Meetings"),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
