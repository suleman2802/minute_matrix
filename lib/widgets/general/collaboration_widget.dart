import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minute_matrix/Providers/user_provider.dart';
import 'package:minute_matrix/widgets/general/add_collaboration_member_dialogue.dart';
import 'package:minute_matrix/widgets/record_offline_meeting/qr_dialogue_widget.dart';
import 'package:provider/provider.dart';

class CollaborationWidget extends StatefulWidget {
  bool isMeetingColaboration;
  String Qrdata;

  CollaborationWidget(this.Qrdata, this.isMeetingColaboration);

  @override
  State<CollaborationWidget> createState() => _CollaborationWidgetState();
}

class _CollaborationWidgetState extends State<CollaborationWidget> {
  int meetingCode = 0000;

  void addMemberInCollaboration(
      String email, bool isManual, String name) async {
    print("inside add member");
    String id =
        Provider.of<UserProvider>(context, listen: false).userDetails.getId();
    await Provider.of<UserProvider>(context, listen: false)
        .addEmailInCollaboration(id, email, isManual, name);
  }

  void addMemberInMeetingCollaboration(String email, bool isPresent,String name) async {
    print("inside add member");
    await Provider.of<UserProvider>(context, listen: false)
        .addEmailInMeetingCollaboration(widget.Qrdata, email, isPresent,name);
  }

  String? userId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userId =
        Provider.of<UserProvider>(context, listen: false).userDetails.getId();
    genrateCode();
    fetchCollaborationMembers();
  }
  fetchCollaborationMembers()async{
    if(widget.isMeetingColaboration){
      await Provider.of<UserProvider>(context, listen: false).getData(widget.Qrdata);
    }
  }

  deleteParticipantFromMeeting(String userid) {
    Provider.of<UserProvider>(context, listen: false)
        .deleteParticipantFromMeetingCollaboration(userid, widget.Qrdata);
  }

  deleteParticipantFromCollaboration(String userid) {
    Provider.of<UserProvider>(context, listen: false)
        .deleteParticipantFromCollaboration(userid);
  }

  genrateCode() async {
    int code = await Provider.of<UserProvider>(context, listen: false)
        .genrateCodeForMeetingCollaboration(widget.Qrdata);
    setState(() {
      meetingCode = code;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Provider.of<UserProvider>(context, listen: false).getData(widget.Qrdata);
    return Card(
      color: Theme.of(context).cardColor,
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Collaboration",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      widget.isMeetingColaboration
                          ? Text(
                              "Code : ${meetingCode}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Text("Collaboration"),
                    //Switch.adaptive(value: true, onChanged: (value) {}),
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.qr_code_2,
                      ),
                      onPressed: () async {
                        if (widget.isMeetingColaboration) {
                          return showAdaptiveDialog(
                              context: context,
                              builder: (context) =>
                                  QrDialogueWidget(widget.Qrdata));
                        } else {
                          // dashboard main collaboration
                          //widget.Qrdata = hostUid;
                          return showAdaptiveDialog(
                              context: context,
                              builder: (context) =>
                                  QrDialogueWidget(widget.Qrdata));
                        }
                      },
                      label: const Text("Generate QR"),
                    ),

                    IconButton(
                      onPressed: () async {
                        if (widget.isMeetingColaboration) {
                          //collaboration  for meeting
                          showAdaptiveDialog(
                              context: context,
                              builder: (context) =>
                                  AddCollaborationMemberDialogue(
                                      addMemberInMeetingCollaboration));
                        } else {
                          //collaboration for dashboard
                          showAdaptiveDialog(
                              context: context,
                              builder: (context) =>
                                  AddCollaborationMemberDialogue(
                                      addMemberInCollaboration));
                        }
                      },
                      icon: Icon(
                        Icons.add,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                // Align(
                //   alignment: Alignment.bottomRight,
                //   child: IconButton(
                //     onPressed: () {},
                //     icon: Icon(Icons.add),
                //   ),
                // ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 200,
                  //color: Colors.grey,
                  child: StreamBuilder(
                      //user = FirebaseAuth.instance.currentUser;
                      stream: //Provider.of<UserProvider>(context).dashboardCollaborationSteam(),
                          widget.isMeetingColaboration
                              ? FirebaseFirestore.instance
                                  .collection("/user")
                                  .doc(userId)
                                  .collection("/meetingData")
                                  .doc("/OfflineMeeting")
                                  .collection(widget.Qrdata)
                                  .doc("/MeetingCollaboration")
                                  .collection("/Participants")
                                  .orderBy("email")
                                  .snapshots()
                              : FirebaseFirestore.instance
                                  .collection("/user")
                                  .doc(userId)
                                  .collection("/collaboration")
                                  .orderBy("email")
                                  .snapshots(),
                      builder: (context, Snapshot) {
                        if (Snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (Snapshot.connectionState == ConnectionState.none) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (Snapshot.hasError) {
                          return const Text(
                              "Unable to retrieve Collaboration members right now");
                        }
                        if (Snapshot.hasData) {
                          var memberDocs = Snapshot.data!.docs;
                          return ListView.builder(
                            reverse: false,
                            itemCount: memberDocs.length,
                            itemBuilder: (context, index) => Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    memberDocs[index]["email"],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      // color: Colors.black,
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.person_add_alt_1_rounded,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  subtitle: Text(
                                    widget.isMeetingColaboration
                                        ? memberDocs[index]["attendance"]
                                        : memberDocs[index]["method"],
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      widget.isMeetingColaboration
                                          ? deleteParticipantFromMeeting(
                                              memberDocs[index]["userId"])
                                          : deleteParticipantFromCollaboration(
                                              memberDocs[index]["userId"]);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                const Divider(),
                              ],
                            ),
                          );
                        } else {
                          return const Text("There is no data to display");
                        }
                      }),
                ),
              ],
            ),
          ),
          // SizedBox(
          //   height: 5,
          // ),
        ],
      ),
    );
  }
}
//
//   ListTile(
//   title: Text(
//   "Suleman",
//   style: TextStyle(
//   fontWeight: FontWeight.w500,
//   // color: Colors.black,
//   ),
//   ),
//   leading: Icon(
//   Icons.person_add_alt_1_rounded,
//   color: Theme.of(context).primaryColor,
//   ),
//   trailing: Text(
//   "QR Scanned",
//   style: TextStyle(
//   color: Theme.of(context).primaryColor,
//   ),
//   ),
//   ),
//   Divider(),
//   ListTile(
//   title: Text(
//   "Suleman",
//   style: TextStyle(
//   fontWeight: FontWeight.w500,
//   //color: Colors.black,
//   ),
//   ),
//   leading: Icon(
//   Icons.person_add_alt_1_rounded,
//   color: Theme.of(context).primaryColor,
//   ),
//   trailing: Text(
//   "Added by Admin",
//   style: TextStyle(
//   color: Theme.of(context).primaryColor,
//   ),
//   ),
//   ),
//   Divider(),
//
// }

// Widget listTileWidget() {
//   return Column(
//   ListTile(
//   title: Text(
//   "Suleman",
//   style: TextStyle(
//   fontWeight: FontWeight.w500,
//   // color: Colors.black,
//   ),
//   ),
//   leading: Icon(
//   Icons.person_add_alt_1_rounded,
//   color: Theme.of(context).primaryColor,
//   ),
//   trailing: Text(
//   "QR Scanned",
//   style: TextStyle(
//   color: Theme.of(context).primaryColor,
//   ),
//   ),
//   ),
//   Divider(),
//       );
// }
