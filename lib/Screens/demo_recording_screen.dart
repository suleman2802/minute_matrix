import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:minute_matrix/Screens/auth_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../Providers/user_auth_provider.dart';
import '../Providers/user_provider.dart';

class DemoRecordingScreen extends StatefulWidget {
  static const String routeName = "./demoRecordingScreen";

  const DemoRecordingScreen({super.key});

  @override
  State<DemoRecordingScreen> createState() => _DemoRecordingScreenState();
}

class _DemoRecordingScreenState extends State<DemoRecordingScreen> {
  bool isRecording = false;
  String _audioFilePath = '';
  FlutterSoundRecorder? _audioRecorder;
  bool isPaused = false;
  final AudioPlayer _player = AudioPlayer();
  String? username;
  String? email;
  String? password;
  final TextEditingController ipAddressController = TextEditingController();

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
    //}
    // }
  }

  Future<String> getAudioDuration() async {
    await _player.setFilePath(_audioFilePath);

    String duration = _player.duration.toString();

    List<String> parts = duration!.split(':');
    String minutes = parts[1];
    var seconds = parts[2].split('.')[0];

    // Format the final string
    // String formattedDuration = '$minutes:$seconds';
    return seconds;
  }

  Future<bool> _uploadAudio() async {
    bool result = false;
    String duration = await getAudioDuration();
    print(int.parse(duration));
    if (int.parse(duration) > 5) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      result = await userProvider.uploadAudioDemoAudio(
          _audioFilePath, ipAddressController.text.trim(), username!);
      await Provider.of<UserAuthProvider>(context, listen: false)
          .createNewUser(email!, password!, username!);
    } else {
      showSnackBar(
          "Record at least 6 second length audio");
    }
    return result;
  }

  Future<void> _stopRecording() async {
    print("inside stop");

    print("inside if");

    await _audioRecorder!.stopRecorder();

    final result = await _uploadAudio();
    if (result) {
      showSnackBar("Account created successfully, Please Login again");
      Navigator.of(context).pushNamed(AuthScreen.routeName);
    } else {
      showSnackBar("Error Creating your account try again later");
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
  Widget build(BuildContext context) {
    final receiveData = ModalRoute.of(context)!.settings.arguments as Map;
    username = receiveData["username"];
    email = receiveData["email"];
    password = receiveData["password"];
    return Scaffold(
      appBar: AppBar(
        title: Text("Minute Matrix"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: ipAddressController,
                decoration: InputDecoration(
                    labelText: "Server Ip Address", hintText: "192.165.8.9"),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Welcome to Minute Matrix! To get started, we need to record a short voice sample. Please read the following sentence clearly and at a steady pace:",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            // SizedBox(
            //   height: 35,
            // ),
            Card(
              margin: EdgeInsets.all(16),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(20),
              //   border: Border.all(color: Theme.of(context).primaryColor),
              // ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                    "Climate change is a pressing global issue that affects all of us. It's important to take steps towards reducing our carbon footprint by using renewable energy, conserving water, and minimizing waste. Small actions, like recycling and using public transportation, can make a big difference. Together, we can work towards a more sustainable future for our planet. Let's all do our part to protect the environment for future generations."),
              ),
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
                          "Let's Get Started",
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
