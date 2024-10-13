import 'package:flutter/material.dart';
import 'package:minute_matrix/Providers/user_provider.dart';
import 'package:minute_matrix/widgets/meeting_detail_screen/update_summary_dialogue.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../widgets/meeting_detail_screen/edit_summary_dialogue.dart';

class SummaryScreen extends StatefulWidget {
  String meeetingName;
  String meetingType;
  bool canEdit;

  SummaryScreen(this.meeetingName, this.meetingType, this.canEdit);

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await Future.delayed(
        Duration(seconds: 1)); // Add a delay to ensure proper initialization
    await flutterTts.setLanguage("en-US");
  }

  Future<Map<String, dynamic>> getSummaryData() async {
    return await Provider.of<UserProvider>(context)
        .fetchMeetingTasks(widget.meeetingName,"${widget.meetingType}Meeting");
  }

  @override
  Widget build(BuildContext context) {
    return
        //   SingleChildScrollView(
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text(
        //         "Topic Discussed : ",
        //         style: Theme.of(context).textTheme.titleMedium,
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //           children: [
        //             ElevatedButton(
        //               onPressed: () {},
        //               child: Text("topic 1"),
        //             ),
        //             ElevatedButton(
        //               onPressed: () {},
        //               child: Text("topic 2"),
        //             ),
        //             ElevatedButton(
        //               onPressed: () {},
        //               child: Text("topic 3"),
        //             ),
        //           ],
        //         ),
        //       ),
        //       SizedBox(
        //         height: 10,
        //       ),
        //       Text(
        //         "Summary : ",
        //         style: Theme.of(context).textTheme.titleMedium,
        //       ),
        //       Text("   Summary of the meeting is over here"),
        //     ],
        //   ),
        // );
        FutureBuilder<Map<String, dynamic>>(
      future: getSummaryData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.data?['topicDiscussed']['topics'] == null &&
            snapshot.data?['taskAssign']['tasks'] == null
            // && snapshot.data?['taskDone']['tasks'] == null
        ) {
          return Center(child: Text('No Meeting Summary avaliable'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No Data Found'));
        } else {
          final data = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Topic Discussed',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  widget.canEdit
                      ? IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => EditSummaryDialogue(
                                  "Edit Topic Discussed",
                                  widget.meetingType,
                                  widget.meeetingName,
                                  data['topicDiscussed']['topics'],
                                  1),
                            );
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : SizedBox(),
                ],
              ),
              ...List<Widget>.from(data['topicDiscussed']['topics']
                  .map((topic) => pointWidget(context, topic))),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Task Assign',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  widget.canEdit
                      ? IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => EditSummaryDialogue(
                                  "Edit Topic Discussed",
                                  widget.meetingType,
                                  widget.meeetingName,
                                  data['taskAssign']['tasks'],
                                  2),
                            );
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : SizedBox(),
                ],
              ),
              ...List<Widget>.from(data['taskAssign']['tasks']
                  .map((task) => pointWidget(context, task))),
              const SizedBox(height: 16.0),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       'Task Done',
              //       style: Theme.of(context).textTheme.displayLarge,
              //     ),
              //     widget.canEdit
              //         ? IconButton(
              //             onPressed: () {
              //               showDialog(
              //                 context: context,
              //                 builder: (context) => EditSummaryDialogue(
              //                     "Edit Topic Discussed",
              //                     widget.meetingType,
              //                     widget.meeetingName,
              //                     data['taskDone']['tasks'],
              //                     3),
              //               );
              //             },
              //             icon: Icon(
              //               Icons.edit,
              //               color: Theme.of(context).primaryColor,
              //             ),
              //           )
              //         : SizedBox(),
              //   ],
              // ),
              // ...List<Widget>.from(data['taskDone']['tasks']
              //     .map((task) => pointWidget(context, task))),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Summary',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Row(
                    children: [
                      widget.canEdit
                          ? IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => UpdateSummaryDialogue(
                                      "Update Summary",
                                      widget.meetingType,
                                      widget.meeetingName,
                                      TrimSummary(data['summary']['summary'] ??
                                          'No Summary'),
                                      true),
                                );
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Theme.of(context).primaryColor,
                              ),
                            )
                          : SizedBox(),
                      SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        onPressed: () => _speak(TrimSummary(
                            data['summary']['summary'] ?? 'No Summary')),
                        icon: const Icon(Icons.play_circle),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                TrimSummary(data['summary']['summary'] ?? 'No Summary'),
              ),
              SizedBox(
                height: 150,
              ),
            ],
          );
        }
      },
    );
  }

  String TrimSummary(String summary) {
    if (summary.substring(2, 3) == "n") {
      summary = summary.substring(3, summary.length - 2);
    }
    return summary;
  }

  Future<void> _speak(String text) async {
    await flutterTts.setSpeechRate(0.5); // Set the speech rate
    await flutterTts.setPitch(1.0); // Set the pitch
    await flutterTts.speak(text);
  }

  // await flutterTts.setSpeechRate(0.5); // Set the speech rate
  // await flutterTts.setPitch(1.0); // Set the pitch
  //
  // await flutterTts.speak(text);

  Row pointWidget(BuildContext context, String data) {
    return Row(
      children: [
        SizedBox(
          width: 15,
        ),
        Icon(
          Icons.circle,
          color: Theme.of(context).primaryColor,
          size: 10,
        ),
        // Container(
        //   height: 10,
        //   width: 10,
        //   decoration: BoxDecoration(
        //       color: Theme.of(context).primaryColor,
        //       borderRadius: BorderRadius.circular(5),),
        // ),
        SizedBox(
          width: 15,
        ),
        Expanded(child: Text(data)),
        IconButton(
          onPressed: () => _speak(data),
          icon: const Icon(Icons.play_circle),
        ),
      ],
    );
  }
}
