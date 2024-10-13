import 'package:flutter/material.dart';

class EditDialogueWidget extends StatefulWidget {
  int index;
  int sequence;
  String dialogue;
  var updateDialogue;


  EditDialogueWidget(
      this.index, this.sequence, this.dialogue, this.updateDialogue);

  @override
  State<EditDialogueWidget> createState() => _EditDialogueWidgetState();
}

class _EditDialogueWidgetState extends State<EditDialogueWidget> {
  final TextEditingController dialogueController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dialogueController.text = widget.dialogue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Dialogue"),
      actions: [
        ElevatedButton(
          onPressed: () {

            widget.updateDialogue(
                widget.index, widget.sequence, dialogueController.text.trim());
          },
          child: Text("Edit"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop,
          child: Text("Cancel"),
        ),
      ],
      content: Padding(
        padding: EdgeInsets.all(12),
        child: TextFormField(
          controller: dialogueController,
        ),
      ),
    );
  }
}
