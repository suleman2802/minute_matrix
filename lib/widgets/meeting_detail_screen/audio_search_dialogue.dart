import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class AudioSearchDialogue extends StatefulWidget {
  var SearchApproximately;

  AudioSearchDialogue(this.SearchApproximately);

  @override
  _AudioSearchDialogueState createState() => _AudioSearchDialogueState();
}

class _AudioSearchDialogueState extends State<AudioSearchDialogue> {
  late stt.SpeechToText _speech;
  bool _isListening = false;

  //String _transcription = '';
  final TextEditingController transcriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // await Permission.microphone.request();
    _speech = stt.SpeechToText();
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('Status: $status'),
      onError: (errorNotification) => print('Error: $errorNotification'),
    );
    if (available) {
      setState(() {
        _isListening = true;
      });
      _speech.listen(
        onResult: (result) {
          setState(() {
            transcriptionController.text = result.recognizedWords;
          });
        },
      );
    } else {
      setState(() {
        _isListening = false;
      });
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Real-time Transcription"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            controller: transcriptionController,
            //decoration: InputDecoration(),
          ),
          // Text(_transcription),
          const SizedBox(height: 20),
          IconButton(
            icon: Icon(_isListening ? Icons.stop : Icons.mic),
            onPressed: () {
              if (_isListening) {
                _stopListening();
              } else {
                _startListening();
              }
            },
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text("Cancel"),
          onPressed: () {
            _stopListening();
            //widget.SearchApproximately(transcriptionController.text.trim());
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text("Search"),
          onPressed: () {
            _stopListening();
            widget.SearchApproximately(transcriptionController.text.trim());
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
