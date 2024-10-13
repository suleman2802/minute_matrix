import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minute_matrix/widgets/meeting_detail_screen/collaboration_edit_dialogue.dart';
import 'package:provider/provider.dart';
import '../Providers/user_provider.dart';

class CollaborationScreen extends StatefulWidget {
  String meetingName;
  String meetingType;
  bool canEdit;

  CollaborationScreen(this.meetingName, this.meetingType, this.canEdit);

  @override
  State<CollaborationScreen> createState() => _CollaborationScreenState();
}

class _CollaborationScreenState extends State<CollaborationScreen> {
  // shareMeetingData(BuildContext context) async {
  deleteParticipants(String userId) {
    Provider.of<UserProvider>(context, listen: false)
        .deleteParticipantFromMeetingCollaboration(userId, widget.meetingName);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 5,
        ),
        Text(
          "Participants : ",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        FutureBuilder<List<Map<String, dynamic>>>(
            future: Provider.of<UserProvider>(context)
                .fetchMeetingCollaboration(
                    widget.meetingName, widget.meetingType),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No Data Found'));
              } else {
                final data = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              data[index]["email"],
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                // color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              data[index]["attendance"],
                              style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                // color: Colors.black,
                              ),
                            ),
                            leading: Icon(
                              Icons.person_add_alt_1_rounded,
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) => CollaborationEditDialogue(
                                    data[index]["userId"],
                                    data[index]["attendance"],
                                    widget.meetingName,
                                    data[index]["email"]),
                              ),
                            ),
                          ),
                          Divider(),
                        ],
                      );
                    },
                  ),
                );
              }
            }),
      ],
    );
  }
}
