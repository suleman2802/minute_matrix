import 'package:flutter/material.dart';
import 'package:minute_matrix/Providers/user_provider.dart';
import 'package:provider/provider.dart';

class CollaborationEditDialogue extends StatefulWidget {
  String userId;
  String Status;
  String meetingName;
  String email;

  CollaborationEditDialogue(
      this.userId, this.Status, this.meetingName, this.email);

  @override
  State<CollaborationEditDialogue> createState() =>
      _CollaborationEditDialogueState();
}

class _CollaborationEditDialogueState extends State<CollaborationEditDialogue> {
  updateStatus() async {
    await Provider.of<UserProvider>(context, listen: false)
        .updateAttendance(widget.userId, selectedOption, widget.meetingName);
    Navigator.of(context).pop();
  }

  final TextEditingController emailController = TextEditingController();
  List<String> options = ["Present", "Absent"];
  String selectedOption = "Present";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController.text = widget.email;
    selectedOption = widget.Status;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
      title: const Text('Edit Participant'),
      actions: [
        ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          onPressed: updateStatus,
          child: const Text('Update'),
        ),
      ],
      content: SizedBox(
        height: 150,
        width: double.maxFinite,
        child: Column(
          children: [
            TextFormField(
              enabled: false,
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            SizedBox(
              height: 10,
            ),
            DropdownMenu(
              initialSelection: selectedOption,
              onSelected: (value) async {
                setState(() {
                  selectedOption = value!;
                });
              },
              width: 200,
              dropdownMenuEntries: options
                  .map<DropdownMenuEntry<String>>(
                    (data) => DropdownMenuEntry(
                      label: data,
                      value: data,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
