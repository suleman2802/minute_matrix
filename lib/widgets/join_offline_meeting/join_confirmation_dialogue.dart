import 'package:flutter/material.dart';
import 'package:minute_matrix/Providers/user_provider.dart';
import 'package:minute_matrix/Screens/home_screen.dart';
import 'package:provider/provider.dart';

class JoinConfirmationDialogue extends StatelessWidget {
  bool isMeetingCollaboration;
  String content;
  String meetingId;

  JoinConfirmationDialogue(
      this.isMeetingCollaboration, this.content, this.meetingId);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Join Collaboration Confirmation"),
      content: Text(isMeetingCollaboration
          ? "Would you like to join meeting collaboration for this meeting $content"
          : "Would you like to join Collaboration Genrated by $content"),
      actions: [
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(), child: Text("No")),
        ElevatedButton(
            onPressed: () async {

              if (!isMeetingCollaboration) {
                String email = Provider.of<UserProvider>(context, listen: false)
                    .userDetails
                    .getEmail();
                String name = Provider.of<UserProvider>(context, listen: false)
                    .userDetails
                    .getName();
                Provider.of<UserProvider>(context, listen: false)
                    .addEmailInCollaboration(meetingId, email, false,name );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('You are added successfully in collaboration'),
                  ),
                );
                Navigator.of(context).pushNamed(HomeScreen.routeName);
              } else {
                //for meeting collaboration
                String hostId = meetingId.substring(0, 28);
                String email = Provider.of<UserProvider>(context, listen: false)
                    .userDetails
                    .getEmail();
                bool result =
                    await Provider.of<UserProvider>(context, listen: false)
                        .markAttendance(
                  hostId,
                  meetingId,
                  email,
                );
                if (result) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'You are added successfully in meeting collaboration'),
                    ),
                  );
                  Navigator.of(context).pushNamed(HomeScreen.routeName);
                } else {
                  const SnackBar(
                    content:
                        Text('You are already  added in meeting collaboration'),
                  );
                  Navigator.of(context).pushNamed(HomeScreen.routeName);
                }
              }
            },
            child: const Text("Yes")),
      ],
    );
  }
}
