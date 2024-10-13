import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../Providers/user_provider.dart';

class SelectParticipantsDialogue extends StatefulWidget {
  final String meetingName;
  final String meetingType;
  bool isShareMeetingData;

  SelectParticipantsDialogue(
      this.meetingName, this.meetingType, this.isShareMeetingData);

  @override
  _SelectParticipantsDialogueState createState() =>
      _SelectParticipantsDialogueState();
}

class _SelectParticipantsDialogueState
    extends State<SelectParticipantsDialogue> {
  bool? canReload;
  bool isLoading = false;

  // List of selected userIds
  List<String> selectedUsers = [];

  shareMeetingData(String userId) async {
    await Provider.of<UserProvider>(context, listen: false)
        .shareMeetingData(widget.meetingName, userId);
  }

  Future<void> sendMOMToParticipants() async {
    print(selectedUsers);
    List<String> emailList = selectedUsers;
    // [
    //   "bhattisuleman2002@gmail.com",
    //   "officeworking1122@gmail.com"
    // ];
    final userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      // Define the path to the document in Firebase Storage
      String filePath =
          '${userId}/${widget.meetingType}Meeting/${userId + widget.meetingName}/MOM.docx';
      Reference storageReference =
          FirebaseStorage.instance.ref().child(filePath);

      // Get the temporary directory to store the downloaded file
      final Directory tempDir = await getTemporaryDirectory();
      final File tempFile = File('${tempDir.path}/MOM.docx');

      // Download the file from Firebase Storage
      await storageReference.writeToFile(tempFile);

      // Create the email with multiple recipients
      final Email email = Email(
        body: 'Please find the attached MOM document.',
        subject: 'MOM Document',
        recipients: emailList,
        // Provide the entire list here
        attachmentPaths: [tempFile.path],
        isHTML: false,
      );

      // Send the email
      await FlutterEmailSender.send(email);

      print('Email sent successfully to all recipients');
    } catch (e) {
      print('Failed to send emails: $e');
    }
  }

  // Toggle selection of a participant
  void toggleSelection(String userId) {
    setState(() {
      if (selectedUsers.contains(userId)) {
        selectedUsers.remove(userId);
      } else {
        selectedUsers.add(userId);
      }
    });
  }

  // Share selected userIds
  Future<void> shareSelectedParticipants() async {
    // print("Selected User IDs: $selectedUsers");
    setState(() {
      isLoading = true;
    });

    for (int i = 0; i < selectedUsers.length; i++) {
      await shareMeetingData(selectedUsers[i]);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Meeting Shared with Participants"),
      ),
    );
    Navigator.of(context).pop();
  }

  Future<List<Map<String, dynamic>>> fetchParticipantsList() async {
    setState(() {
      canReload = false;
    });
    return await Provider.of<UserProvider>(context, listen: false)
        .fetchMeetingCollaboration(widget.meetingName, widget.meetingType);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    canReload = true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Select Participants"),
      actions: [
        ElevatedButton(
          onPressed: widget.isShareMeetingData
              ? shareSelectedParticipants
              : sendMOMToParticipants,
          child: isLoading ? CircularProgressIndicator() : Text("Share"),
        ),
      ],
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: FutureBuilder(
          future: canReload! ? fetchParticipantsList() : null,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No Participants Found'));
            } else {
              final data = snapshot.data!;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  final isSelected = widget.isShareMeetingData
                      ? selectedUsers.contains(data[index]['userId'])
                      : selectedUsers.contains(data[index]['email']);
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          data[index]["name"],
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          data[index]["email"],
                          // style: const TextStyle(
                          //   fontWeight: FontWeight.w500,
                          // ),
                        ),
                        leading: Checkbox(
                          value: isSelected,
                          onChanged: (bool? value) {
                            toggleSelection(widget.isShareMeetingData
                                ? data[index]['userId']
                                : data[index]['email']);
                          },
                        ),
                      ),
                      Divider(),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
