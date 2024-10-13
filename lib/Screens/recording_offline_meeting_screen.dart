import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../Providers/user_provider.dart';
import '../widgets/record_offline_meeting/qr_dialogue_widget.dart';
import './home_screen.dart';

class RecordingOfflineMeetingScreen extends StatefulWidget {
  static const String routeName = "./recordingOfflineMeetingScreen";

  @override
  State<RecordingOfflineMeetingScreen> createState() =>
      _RecordingOfflineMeetingScreenState();
}

class _RecordingOfflineMeetingScreenState
    extends State<RecordingOfflineMeetingScreen> {
  bool isRecording = false;
  String _audioFilePath = '';
  final AudioPlayer _player = AudioPlayer();

  // bool _isListening = false;
  FlutterSoundRecorder? _audioRecorder;

  bool isCollaborationEnabled = false;

  // bool isCaptionsEnabled = false;
  bool isPaused = false;
  String qrData = "";
  String ipAddress = "";
  String meetingName = "";

  @override
  void initState() {
    super.initState();
    _audioRecorder = FlutterSoundRecorder();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    await _audioRecorder!.openRecorder();
  }

  Future<void> _startRecording() async {
    Directory? fileDownloadPath = await getDownloadsDirectory();
    _audioFilePath = '${fileDownloadPath!.path}/audio_recording.wav';
    await _audioRecorder!.startRecorder(toFile: _audioFilePath);
  }

  Future<String> getAudioDuration() async {
    await _player.setFilePath(_audioFilePath);

    String duration = _player.duration.toString();

    List<String> parts = duration!.split(':');
    String minutes = parts[1];
    var seconds = parts[2].split('.')[0];

    // Format the final string
    String formattedDuration = '$minutes:$seconds';
    return formattedDuration;
  }

  Future<bool> _uploadAudio() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    bool result = await userProvider.uploadAudio(
        _audioFilePath, ipAddress, meetingName, "OfflineMeeting");
    String duration = await getAudioDuration();
    bool result2 = await userProvider.addMeetingNameAndDuration(
        meetingName, "OfflineMeeting", duration);
    return result & result2;
  }

  Future<void> _stopRecording() async {
    print("inside stop");
    // if (_isListening) {
    print("inside if");
    //await _speech.stop();
    await _audioRecorder!.stopRecorder();
    // setState(() {
    //   _isListening = false;
    // });
    //}
    // showSnackBar("meeting recording stoped");
    final result = await _uploadAudio();
    if (result) {
      showSnackBar("meeting recording uploaded");
      Navigator.of(context).pushNamed(HomeScreen.routeName);
    } else {
      showSnackBar("meeting recording failed");
    }
  }

  showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pauseRecording() async {
    await _audioRecorder!.pauseRecorder();
    setState(() {
      isPaused = true;
      //_isListening = false;
    });
  }

  Future<void> _resumeRecording() async {
    await _audioRecorder!.resumeRecorder();
    setState(() {
      isPaused = false;
      //_isListening = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _audioRecorder!.closeRecorder();
    _player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final receiveData = ModalRoute.of(context)!.settings.arguments as Map;
    ipAddress = receiveData["ipAddress"];
    isCollaborationEnabled = receiveData["isCollaborationEnabled"];
    // isCaptionsEnabled = receiveData["isCaptionsEnabled"];
    qrData = receiveData["qrData"];
    meetingName = receiveData["meetingName"];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          !isPaused
              ? "Recording Offline Meeting"
              : "Meeting Recording is Paused",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(
            //   "Meeting Name ",
            //   style: Theme.of(context).textTheme.displayLarge,
            // ),
            const SizedBox(
              height: 10,
            ),
            isCollaborationEnabled ? QrDialogueWidget(qrData) : SizedBox(),

            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                !isRecording
                    ? FloatingActionButton.extended(
                        label: const Text(
                          "Start Recording",
                        ),
                        onPressed: () {
                          _startRecording();
                          setState(() {
                            isRecording = true;
                            isPaused = false;
                          });
                        },
                      )
                    : FloatingActionButton(
                        onPressed: () {
                          // if (isRecording) {
                          //print("isRecoding ${isRecording.toString()}");
                          if (isPaused) {
                            print("if pause");
                            print("isPaused ${isPaused.toString()}");
                            _resumeRecording();
                          } else {
                            print("else pause");
                            print("isPaused ${isPaused.toString()}");
                            _pauseRecording();
                          }
                          //}
                        },
                        child: isPaused
                            ? Icon(Icons.play_arrow)
                            : Icon(Icons.pause),
                      ),
                SizedBox(
                  width: 1,
                ),
                isRecording
                    ? FloatingActionButton(
                        onPressed: _stopRecording,
                        child: const Icon(Icons.stop),
                      )
                    : const SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
