import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/user_provider.dart';

class AddCollaborationMemberDialogue extends StatefulWidget {
  var addMembermethod;

  AddCollaborationMemberDialogue(this.addMembermethod);

  @override
  State<AddCollaborationMemberDialogue> createState() =>
      _AddCollaborationMemberDialogueState();
}

class _AddCollaborationMemberDialogueState
    extends State<AddCollaborationMemberDialogue> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();

  Future<bool> isValidUser(String userEmail) async {
    String result = await Provider.of<UserProvider>(context, listen: false)
        .findUserByEmail(userEmail);
    return result.isNotEmpty;
  }

  Future<bool> isUniqueUser(String userEmail) async {
    bool isDuplicate = await Provider.of<UserProvider>(context, listen: false)
        .isAlreadyAddedInDashboardCollaboration(userEmail);
    return !isDuplicate;
  }

  bool isValidCredential() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      return true;
      //submitForm();
      //submitbtn(_userEmail, _userName, _password, _isLogin, context);
    }
    return false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _userEmailController.dispose();
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).cardColor,
      title: Text("Add Member for Collaboration"),
      content: Container(
        height: 150,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _userEmailController,
                validator: (value) {
                  if (value!.isEmpty || !value.contains("@")) {
                    return "Enter a valid Email Address";
                  }

                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    labelText: "Email Address",
                    hintText: "e.g example@gmail.com"),
              ),
              TextFormField(
                controller: _userNameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter a Participant name";
                  }
                  if (value.length < 3) {
                    return "Enter a Participant name of atleast 3 character";
                  }

                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    labelText: "Name", hintText: "e.g Suleman"),
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            if (isValidCredential()) {
              if (await isUniqueUser(_userEmailController.text)) {
                if (await isValidUser(_userEmailController.text)) {
                  //user registered found
                  print("if inside");
                  widget.addMembermethod(_userEmailController.text.trim(), true,
                      _userNameController.text.trim());
                  showSnackbar("User added in collaboration Successfully");
                  _userEmailController.clear();
                  Navigator.of(context).pop();
                } else {
                  //user not found
                  showSnackbar("No user found against this email");
                  Navigator.of(context).pop();
                }
              } else {
                showSnackbar("This User is already added in collaboration");
                Navigator.of(context).pop();
              }
            }
          },
          child: const Text("Add Member"),
        ),
      ],
    );
  }
}
