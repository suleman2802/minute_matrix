import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/UserDetails.dart';
import '../../Providers/user_provider.dart';
import '../../Screens/subscription_plans_screen.dart';
import '../../Screens/subscription_usage_Screen.dart';
import './chart_widget.dart';

class MinuteConsumedWidget extends StatefulWidget {
  @override
  State<MinuteConsumedWidget> createState() => _MinuteConsumedWidgetState();
}

class _MinuteConsumedWidgetState extends State<MinuteConsumedWidget> {
  bool isStandard = false;

  double meetingHoursConsumed = 0.0;

  double totalMeetingHours = 0.0;


  getSubriptionPlanDetails() {
    UserDetails userDetails =
        Provider.of<UserProvider>(context,listen: false).userDetails;
    String subcribedPlan = userDetails.getSubscription_plan();
    meetingHoursConsumed = userDetails.getMeeting_hours_consumed();
    totalMeetingHours = userDetails.getTotal_meeting_hours().toDouble();
    if (subcribedPlan == "Standard") {
      isStandard = true;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSubriptionPlanDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      //margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10,),
      elevation: 5,
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChartWidget(meetingHoursConsumed, totalMeetingHours),
            const SizedBox(
              width: 15,
            ),
            Column(
              children: [
                Text(
                  "Minutes Consumed",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                ElevatedButton(
                  onPressed: () => isStandard
                      ? Navigator.of(context)
                          .pushNamed(SubscriptionPlansScreen.routeName)
                      : Navigator.of(context)
                          .pushNamed(SubscriptionUsageScreen.routeName),
                  child:
                      Text(isStandard ? "Upgrade Plan" : "Subscription Usage"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
