import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:minute_matrix/Screens/home_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:minute_matrix/Providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/meeting_detail_screen/audio_player_widget.dart';
import '../widgets/meeting_detail_screen/ip_dialogue.dart';
import '../widgets/meeting_detail_screen/select_participants_dialogue.dart';
import './collaboration_screen.dart';
import './summary_screen.dart';
import './transcription_screen.dart';

class MeetingDetailScreen extends StatefulWidget {
  static const routeName = "./meetingDetailScreen";

  const MeetingDetailScreen({super.key});

  @override
  State<MeetingDetailScreen> createState() => _MeetingDetailScreenState();
}

class _MeetingDetailScreenState extends State<MeetingDetailScreen> {
  int recordingStartSecond = 0;
  bool startWithDialogue = false;

  String? meetingName;
  String? meetingType;
  String? meetingTime;
  String? hostName;
  String? duration;
  String? hostId;
  bool isHost = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getDialogueTime(int startSecond) {
    setState(() {
      recordingStartSecond = startSecond;
      startWithDialogue = true;
    });
  }

  bool canEdit() {
    return hostId ==
        Provider.of<UserProvider>(context, listen: false).userDetails.getId();
  }

  Future<void> _generateMOM() async {
    // Implement the function to generate MOM
    print('Generate MOM');
    showDialog(
      context: context,
      builder: (context) => IpDialogue(meetingName!,meetingType!),
    );
  }

  void _shareMOM() {
    // Implement the function to share MOM
    print('Share MOM');
    meetingType == "Offline"
        ? showDialog(
            context: context,
            builder: (context) =>
                SelectParticipantsDialogue(meetingName!, meetingType!, false),
          )
        : sendMOMToParticipants();
  }

  Future<void> sendMOMToParticipants() async {
    List<String> emailList = [
      Provider.of<UserProvider>(context, listen: false).userDetails.getEmail()
    ];
    // [
    //   "bhattisuleman2002@gmail.com",
    //   "officeworking1122@gmail.com"
    // ];
    final userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      // Define the path to the document in Firebase Storage
      String filePath =
          '${userId}/${meetingType!}Meeting/${userId + meetingName!}/MOM.docx';
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

  void _shareMeetingData() {
    // Implement the function to share meeting data
    print('Share Meeting Data');

    showDialog(
      context: context,
      builder: (context) =>
          SelectParticipantsDialogue(meetingName!, meetingType!, true),
    );
  }

  Future<void> _deleteMeeting() async {
    // Implement the function to delete meeting
    print('Delete Meeting');
    bool result = meetingType == "Offline"
        ? await Provider.of<UserProvider>(context, listen: false)
            .deleteNameFromLatestMeetings(meetingName!)
        : await Provider.of<UserProvider>(context, listen: false)
            .deleteNameFromUploadMeetings(meetingName!);
    if (result) {
      showSnackBar("Meeting Deleted Successfully");
      Navigator.of(context).pushNamed(HomeScreen.routeName);
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
    final receiveData = ModalRoute.of(context)!.settings.arguments as Map;
    meetingName = receiveData["meetingName"];
    duration = receiveData["duration"];
    meetingTime = receiveData["time"];
    meetingType = receiveData["meetingType"];
    hostName = receiveData["hostName"];
    hostId = receiveData["hostId"];

    return Scaffold(
      appBar: AppBar(
          title: const Text("Meeting Details"),
          actions:
              // [
              //   canEdit()
              //       ? IconButton(
              //           onPressed: () => sendDocumentToEmails(),
              //               // showDialog(
              //               //   context: context,
              //               //   builder: (context) => SelectParticipantsDialogue(
              //               //       meetingName!, meetingType!),
              //               // ),
              //           icon: const Icon(Icons.share))
              //       : SizedBox(),
              // ],

              meetingType == "Offline"
                  ? [
                      PopupMenuButton<String>(
                        onSelected: (String result) {
                          switch (result) {
                            case 'Generate MOM':
                              _generateMOM();
                              break;
                            case 'Share MOM':
                              _shareMOM();
                              break;
                            case 'Share Meeting Data':
                              _shareMeetingData();
                              break;
                            case 'Delete Meeting':
                              _deleteMeeting();
                              break;
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'Generate MOM',
                            child: Text('Generate MOM'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'Share MOM',
                            child: Text('Share MOM'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'Share Meeting Data',
                            child: Text('Share Meeting Data'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'Delete Meeting',
                            child: Text('Delete Meeting'),
                          ),
                        ],
                        icon: Icon(Icons.more_vert),
                      )
                      // : IconButton(
                      //     onPressed: _deleteMeeting, icon: Icon(Icons.delete_forever)),
                    ]
                  : [
                      PopupMenuButton<String>(
                        onSelected: (String result) {
                          switch (result) {
                            case 'Generate MOM':
                              _generateMOM();
                              break;
                            case 'Share MOM':
                              _shareMOM();
                              break;
                            // case 'Share Meeting Data':
                            //   _shareMeetingData();
                            //   break;
                            case 'Delete Meeting':
                              _deleteMeeting();
                              break;
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'Generate MOM',
                            child: Text('Generate MOM'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'Share MOM',
                            child: Text('Share MOM'),
                          ),
                          // const PopupMenuItem<String>(
                          //   value: 'Share Meeting Data',
                          //   child: Text('Share Meeting Data'),
                          // ),
                          const PopupMenuItem<String>(
                            value: 'Delete Meeting',
                            child: Text('Delete Meeting'),
                          ),
                        ],
                        icon: Icon(Icons.more_vert),
                      )
                      // : IconButton(
                      //     onPressed: _deleteMeeting, icon: Icon(Icons.delete_forever)),
                    ]),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  meetingName!,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      meetingType!,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                )
                // Icon(
                //   Icons.audiotrack_outlined,
                //   color: Theme.of(context).primaryColor,
                // ),
              ],
            ),
            Expanded(
                child: _tabSection(context, getDialogueTime, meetingType!,
                    meetingName!, canEdit())),
            // Expanded(
            //     child:
            Row(
              children: [
                Text(hostName!),
                const SizedBox(
                  width: 8,
                ),
                Text(meetingTime!),
              ],
            ),
            // ),
          ],
        ),
      ),
      floatingActionButton: AudioPlayerWidget(
        startSeconds: recordingStartSecond,
        startWithDialogue: startWithDialogue,
        meetingName: meetingName!,
        meetingType: meetingType!,
      ),
    );
  }
}

Widget _tabSection(BuildContext context, var getDialogueTime,
    String meetingType, String meetingName, bool canEdit) {
  return DefaultTabController(
    length: meetingType == "Offline" ? 3 : 2,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        meetingType == "Offline"
            ? const TabBar(tabs: [
                Tab(text: "Collaboration"),
                Tab(text: "Transcription"),
                Tab(text: "Summary"),
              ])
            : const TabBar(tabs: [
                Tab(text: "Transcription"),
                Tab(text: "Summary"),
              ]),
        Expanded(
          child: Container(
            //height: MediaQuery.of(context).size.height * 0.65,
            margin: const EdgeInsets.only(top: 5, right: 5, left: 5),
            child: meetingType == "Offline"
                ? TabBarView(
                    children: [
                      CollaborationScreen(
                        meetingName,
                        meetingType,
                        canEdit,
                      ),
                      TranscriptionScreen(
                          meetingName, meetingType, getDialogueTime, canEdit),
                      SummaryScreen(meetingName, meetingType, canEdit),
                    ],
                  )
                : TabBarView(
                    children: [
                      TranscriptionScreen(
                          meetingName, meetingType, getDialogueTime, canEdit),
                      SummaryScreen(meetingName, meetingType, canEdit),
                    ],
                  ),
          ),
        ),
      ],
    ),
  );
}
