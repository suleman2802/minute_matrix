import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/user_provider.dart';
import '../../Screens/about_app_screen.dart';
import '../../Providers/user_auth_provider.dart';
import '../../Screens/privacy_policy_screen.dart';
import '../../Screens/terms_condition_screen.dart';
import '../general/item_heading.dart';
import '../general/single_item.dart';
import './show_helpline_support_dialogue_widget.dart';

class AboutAppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ItemHeading("ABOUT APP"),
        const SizedBox(
          height: 10,
        ),
        InkWell(
          child: SingleItem(Icons.info_outline, "About App"),
          onTap: () =>
              Navigator.of(context).pushNamed(AboutAppScreen.routeName),
        ),
        InkWell(
          child: SingleItem(Icons.privacy_tip_outlined, "Privacy Policy"),
          onTap: () =>
              Navigator.of(context).pushNamed(PrivacyPolicyScreen.routeName),
        ),
        InkWell(
          child: SingleItem(Icons.list_outlined, "Terms & Conditions"),
          onTap: () =>
              Navigator.of(context).pushNamed(TermsConditionScreen.routeName),
        ),
        InkWell(
          child: SingleItem(
            Icons.help_outline_outlined,
            "Help & Support",
          ),
          onTap: () => showAdaptiveDialog(
              context: context,
              builder: (context) {
                return ShowHelplineSupportDialogue(true);
              }),
        ),
        InkWell(
          child: SingleItem(
            Icons.phone_in_talk_outlined,
            "Helpline Number",
          ),
          onTap: () => showAdaptiveDialog(
              context: context,
              builder: (context) {
                return ShowHelplineSupportDialogue(false);
              }),
        ),
        InkWell(
            child: SingleItem(
              Icons.delete_forever,
              "Delete Account",
            ),
            onTap: () async {
              bool result =
                  await Provider.of<UserProvider>(context, listen: false)
                      .deleteUserAccount();
              if (result) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Account Deleted Successfully"),
                  ),
                );
                Navigator.pushNamed(context, "/");
              }
            }),
        InkWell(
          child: SingleItem(Icons.logout_outlined, "Log out"),
          onTap: () async {
            await Provider.of<UserAuthProvider>(context, listen: false)
                .logout();
            Navigator.pushNamed(context, "/");
          },
        ),
      ],
    );
  }
}
