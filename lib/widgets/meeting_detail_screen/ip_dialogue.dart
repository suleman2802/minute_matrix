import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/user_provider.dart';

class IpDialogue extends StatefulWidget {
  String meetingName;
  String meetingType;

  IpDialogue(this.meetingName,this.meetingType);

  @override
  State<IpDialogue> createState() => _IpDialogueState();
}

class _IpDialogueState extends State<IpDialogue> {
  final TextEditingController ipAddressController = TextEditingController();

  genrateMOM() async {
    if (ipAddressController.text.trim().isNotEmpty) {
      bool result = await Provider.of<UserProvider>(context, listen: false)
          .genrateMOM(widget.meetingName, ipAddressController.text.trim(),widget.meetingType);
      if (result) {
        showSnackBar("MOM Document Generation is in process");
        Navigator.of(context).pop();
      } else {
        showSnackBar("Unable to generate MOM");
        Navigator.of(context).pop();
      }
    }else {
      showSnackBar("Ip Address cannot be empty");
    }
  }

  showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: genrateMOM,
          child: Text("Genrate MOM"),
        ),
      ],
      title: Text("Genrate MOM Document"),
      content: TextFormField(
        controller: ipAddressController,
        decoration:
            InputDecoration(hintText: "192.168.1.9", labelText: "Ip Address"),
      ),
    );
  }
}
