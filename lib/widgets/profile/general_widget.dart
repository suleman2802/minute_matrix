import 'package:flutter/material.dart';
import 'package:minute_matrix/Screens/change_username_screen.dart';
import 'package:minute_matrix/Screens/subscription_usage_Screen.dart';

import '../../Screens/change_password_screen.dart';
import '../general/item_heading.dart';
import '../general/single_item.dart';

class GeneralWidget extends StatefulWidget {
  const GeneralWidget({super.key});

  @override
  State<GeneralWidget> createState() => _GeneralWidgetState();
}
 
class _GeneralWidgetState extends State<GeneralWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ItemHeading("GENERAL"),
        InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleItem(Icons.account_circle_outlined, "Change Username"),
              Icon(Icons.arrow_forward_ios),
            ],
          ),
          onTap: () =>
              Navigator.of(context).pushNamed(ChangeUsernameScreen.routeName),
        ),
        InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleItem(Icons.lock_open_outlined, "Change Password"),
              Icon(Icons.arrow_forward_ios),
            ],
          ),
          onTap: () =>
              Navigator.of(context).pushNamed(ChangePasswordScreen.routeName),
        ),
        InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleItem(Icons.data_usage_outlined, "Subscription Usage"),
              Icon(Icons.arrow_forward_ios),
            ],
          ),
          onTap: () {
            Navigator.of(context).pushNamed(SubscriptionUsageScreen.routeName);
          },
        ),
      ],
    );
  }
}
