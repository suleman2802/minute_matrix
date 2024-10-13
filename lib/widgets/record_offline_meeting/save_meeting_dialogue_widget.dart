import 'package:flutter/material.dart';

import '../../Screens/home_screen.dart';
class SaveMeetingDialogueWidget extends StatelessWidget {
  const SaveMeetingDialogueWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text("Save Meeting Recording",style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.w500,
        fontSize: 24,
      ),
      ),
      content: const Text("Are you sure you want to save meeting recording into the system ?",),
      actions: [
        ElevatedButton(onPressed: ()=> Navigator.of(context).pushNamed(HomeScreen.routeName), child: Text("No"),),
        ElevatedButton(onPressed: (){}, child: Text("Yes"),),
      ],
    );
  }
}
