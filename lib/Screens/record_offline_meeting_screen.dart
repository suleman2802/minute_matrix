import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/user_provider.dart';
import '../Screens/recording_offline_meeting_screen.dart';
import '../widgets/general/collaboration_widget.dart';

class RecordOfflineMeetingScreen extends StatefulWidget {
  static const String routeName = "./recordOfflineMeetingScreen";

  @override
  State<RecordOfflineMeetingScreen> createState() =>
      _RecordOfflineMeetingScreenState();
}

class _RecordOfflineMeetingScreenState
    extends State<RecordOfflineMeetingScreen> {
  String hostUid = "";

  final _formKey = GlobalKey<FormState>();
  TextEditingController meetingNameController = TextEditingController();
  TextEditingController ipAddressController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // isCollaborationEnabled = false;
    // isCaptionsEnabled = false;
    hostUid =
        Provider.of<UserProvider>(context, listen: false).userDetails.getId();
  }

  //TextEditingController _nameController = TextEditingController();

  // bool? isCollaborationEnabled;
  // bool? isCaptionsEnabled;
  bool isCollaborationEnabled = false;

  // bool isCaptionsEnabled = false;

  enableCollaboration() async {
    validateFeilds();
    if (meetingNameController.text.length >= 4) {
      await Provider.of<UserProvider>(context, listen: false)
          .addMeetingNameAndDuration(
              meetingNameController.text.trim(), "OfflineMeeting", "0:00")
          .then((value) => setState(() {
                isCollaborationEnabled = !isCollaborationEnabled;
              }));
    }
  }

  validateFeilds() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  showSnackbar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          content,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Record Meeting"),
      ),
      body: Expanded(
        child: SingleChildScrollView(
          child: Container(
            margin:
                const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
            child: Card(
              elevation: 1,
              //margin: EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: meetingNameController,
                        key: const ValueKey("meeting name"),
                        //controller: _nameController,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 4) {
                            return "Enter a Meeting name of at least 4 character";
                          }
                          return null;
                        },
                        // onChanged: (value) {
                        //   setState(() {
                        //     meetingName = value;
                        //   });
                        // },
                        onFieldSubmitted: (value) {
                          // setState(() {
                          //   meetingName = value;
                          // });
                          validateFeilds();
                        },
                        decoration: const InputDecoration(
                            labelText: "Meeting Name",
                            hintText: "e.g XYZ Requirement Gathering"),
                      ),
                      TextFormField(
                        controller: ipAddressController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Server Ip Address";
                          }
                          if (!value.contains(".")) {
                            return "Enter valid Server Ip Address";
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          // setState(() {
                          //   meetingName = value;
                          // });
                          validateFeilds();
                        },
                        decoration: const InputDecoration(
                            labelText: "Server Ip Address",
                            hintText: "e.g 192.168.1.5"),
                      ),
                      // SwitchListTile.adaptive(
                      //   value: isCaptionsEnabled,
                      //   onChanged: (value) {
                      //     validateFeilds();
                      //     if (meetingNameController.text.length > 4) {
                      //       setState(() {
                      //         isCaptionsEnabled = !isCaptionsEnabled;
                      //       });
                      //     }
                      //   },
                      //   title: const Text("Enable captions"),
                      // ),
                      SwitchListTile.adaptive(
                        value: isCollaborationEnabled,
                        onChanged: (value) {
                          validateFeilds();
                          if (!isCollaborationEnabled &&
                              meetingNameController.text.length >= 4) {
                            enableCollaboration();
                          } else {
                            if (meetingNameController.text.length >= 4) {
                              setState(() {
                                isCollaborationEnabled =
                                    !isCollaborationEnabled;
                              });
                            }
                          }
                        },
                        title: const Text("Enable Collaboration"),
                      ),
                      isCollaborationEnabled &&
                              meetingNameController.text.length >= 4
                          ? CollaborationWidget(
                              hostUid + meetingNameController.text.trim(), true)
                          : const SizedBox(),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.mic),
        onPressed: () {
          validateFeilds();
          if (meetingNameController.text.length >= 4) {
            // if (!isCollaborationEnabled) {
            //   Provider.of<UserProvider>(context, listen: false)
            //       .addMeetingName(hostUid + meetingNameController.text.trim(), meetingNameController.text.trim());
            //}
            if (Provider.of<UserProvider>(context,listen: false)
                    .userDetails
                    .getNo_offline_total() >=
                Provider.of<UserProvider>(context,listen: false)
                    .userDetails
                    .getNo_offline_consumed()) {
              Navigator.of(context).pushNamed(
                  RecordingOfflineMeetingScreen.routeName,
                  arguments: {
                    "ipAddress": ipAddressController.text,
                    "isCollaborationEnabled": isCollaborationEnabled,
                    // "isCaptionsEnabled": isCaptionsEnabled,
                    "qrData": hostUid + meetingNameController.text.trim(),
                    "meetingName": meetingNameController.text,
                  });
            }
            else {
              showSnackbar("You have consumed all your offline meeting credits");
            }
          } else {
            showSnackbar("Enter meeting name of atleast 4 character");
          }
        },
        label: const Text("Start Meeting"),
      ),
    );
  }
}
