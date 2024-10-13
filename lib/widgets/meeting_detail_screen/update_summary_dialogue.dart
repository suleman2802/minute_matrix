import 'package:flutter/material.dart';
import 'package:minute_matrix/Screens/meeting_detail_screen.dart';
import 'package:provider/provider.dart';

import '../../Providers/user_provider.dart';

class UpdateSummaryDialogue extends StatefulWidget {
  String meetingType;
  String meetingName;
  String text;
  String title;
  bool isSummary;

  UpdateSummaryDialogue(this.title, this.meetingType, this.meetingName,
      this.text, this.isSummary);

  @override
  State<UpdateSummaryDialogue> createState() => _UpdateSummaryDialogueState();
}

class _UpdateSummaryDialogueState extends State<UpdateSummaryDialogue> {
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textController.text = widget.text;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textController.dispose();
  }

  final TextEditingController textController = TextEditingController();

  updateSummary() {
    Provider.of<UserProvider>(context, listen: false).updateSummary(
        widget.meetingName, widget.meetingType, textController.text.trim());
    Navigator.of(context).pop();
  }

  updateSpeakerName() async {
    setState(() {
      isLoading = true;
    });
    bool result = await Provider.of<UserProvider>(context, listen: false)
        .updateSpeakerName(widget.meetingName, widget.meetingType, widget.text,
            textController.text.trim());
    if (result) {
      showSnackbar("Speaker Name updated Successfully");
    } else {
      showSnackbar("Unable to update Speaker Name");
    }
    Navigator.of(context).pop();
  }

  showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
      title: Text(widget.title,style: TextStyle(
        color: Colors.black,
      ),),
      content: Padding(
        padding: const EdgeInsets.all(12),
        child: TextFormField(
          style: TextStyle(
            color: Colors.black,
          ),
          controller: textController,
          decoration: InputDecoration(),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: widget.isSummary ? updateSummary : updateSpeakerName,
          child: isLoading
              ? CircularProgressIndicator(
                  color: Colors.white,
                )
              : Text("Update"),
        ),
      ],
    );
  }
}
