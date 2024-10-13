import 'package:minute_matrix/Providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class EditSummaryDialogue extends StatefulWidget {
  List<dynamic> points;
  String meetingType;
  String meetingName;
  String title;
  int type;

  EditSummaryDialogue(
      this.title, this.meetingType, this.meetingName, this.points, this.type);

  @override
  State<EditSummaryDialogue> createState() => _EditSummaryDialogueState();
}

class _EditSummaryDialogueState extends State<EditSummaryDialogue> {
  void updateFirebase() {
    if (widget.type == 1) {
      Provider.of<UserProvider>(context, listen: false).updateTopicDiscussed(
          widget.meetingName, widget.meetingType, widget.points);
    }
    if (widget.type == 2) {
      Provider.of<UserProvider>(context, listen: false).updateTaskAssign(
          widget.meetingName, widget.meetingType, widget.points);
    }
    if (widget.type == 3) {
      Provider.of<UserProvider>(context, listen: false).updateTaskDone(
          widget.meetingName, widget.meetingType, widget.points);
    }
  }

  void _addNewTopic(BuildContext context, List<dynamic> points) {
    TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
          title: const Text('Add New Topic'),
          content: TextField(
            style: TextStyle(
              color: Colors.black,
            ),
            controller: _controller,
            decoration: const InputDecoration(
              hintText: "Enter new topic",
            ),
          ),
          actions: [
            ElevatedButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  points.add(_controller.text);
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _editSingleTopic(BuildContext context, List<dynamic> points, int index) {
    TextEditingController _controller =
        TextEditingController(text: points[index]);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
          title: Text(
            widget.title,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          content: TextField(
            controller: _controller,
          ),
          actions: [
            ElevatedButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  points[index] = _controller.text;
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
          ),
          IconButton.filled(
            onPressed: () => _addNewTopic(context, widget.points),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.points.length,
          itemBuilder: (context, index) {
            return widget.points.length > 0
                ? Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.circle,
                          color: Theme.of(context).primaryColor,
                          size: 10,
                        ),
                        title: Text(widget.points[index]),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () =>
                              _editSingleTopic(context, widget.points, index),
                        ),
                      ),
                      Divider(),
                    ],
                  )
                : const Text("No Task available,Add task first");
          },
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text('Update'),
          onPressed: () {
            updateFirebase();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
