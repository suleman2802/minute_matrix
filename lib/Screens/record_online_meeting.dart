import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/user_provider.dart';
import './home_screen.dart';

class RecordOnlineMeetingScreen extends StatefulWidget {
  static const String routeName = "./recordOnlineMeetingScreen";

  @override
  State<RecordOnlineMeetingScreen> createState() =>
      _RecordOfflineMeetingScreenState();
}

class _RecordOfflineMeetingScreenState
    extends State<RecordOnlineMeetingScreen> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    meetingNameController.clear();
    ipAddressController.clear();
    _player.dispose();
  }

  String fileName = "Pick Meeting Audio Recording";
  File? audioFile;
  final AudioPlayer _player = AudioPlayer();

  //String? duration;
  final _formKey = GlobalKey<FormState>();
  TextEditingController meetingNameController = TextEditingController();
  TextEditingController ipAddressController = TextEditingController();

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

  void pickAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'm4a', 'aac'],
    );

    if (result != null) {
      PlatformFile file = result.files.single;

      if (['mp3', 'wav', 'm4a', 'aac'].contains(file.extension)) {
        setState(() {
          fileName = file.name;
          audioFile = File(file.path!);
        });

        showSnackbar('File attached successfully');
        //getAudioDuration();
      } else {
        showSnackbar('Please attach a valid audio file');
      }
    } else {
      // User canceled the picker
      showSnackbar('No file selected');
    }
  }

  Future<String> getAudioDuration() async {
    await _player.setFilePath(audioFile!.path);

    String duration = _player.duration.toString();

    List<String> parts = duration!.split(':');
    String minutes = parts[1];
    var seconds = parts[2].split('.')[0];

    // Format the final string
    String formattedDuration = '$minutes:$seconds';
    return formattedDuration;
  }

  Future<bool> uploadAudio() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    print("total : ${userProvider.userDetails.getNo_upload_total()}");
    print("used : ${userProvider.userDetails.getNo_upload_consumed()}");
    if(userProvider.userDetails.getNo_upload_total() >= userProvider.userDetails.getNo_upload_consumed()) {
      bool result = await userProvider.uploadAudio(
          audioFile!.path,
          ipAddressController.text.trim(),
          meetingNameController.text.trim(),
          "UploadMeeting");
      print("result : $result");
      String duration = await getAudioDuration();
      bool result2 = await userProvider.addMeetingNameAndDuration(
          meetingNameController.text.trim(), "UploadMeeting", duration);
      return result && result2;
    }else{
      showSnackbar("You have used all your upload meeting limit,Upgrade Plan");
      return false;
    }
  }

  // Future<void> uploadAudioFile(String filePath) async {
  //   if (audioFile == null) return;
  //
  //   var url = Uri.parse('http://your_ip_address:4500/upload');
  //   var request = https.MultipartRequest('POST', url);
  //   request.files.add(await https.MultipartFile.fromPath('file', filePath));
  //
  //   var response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('File uploaded successfully')),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to upload file')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Meeting Recording"),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
        child: Card(
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
                    onFieldSubmitted: (value) {
                      validateFeilds();
                    },
                    decoration: const InputDecoration(
                        labelText: "Meeting Name",
                        hintText: "e.g WXYZ Requirement Gathering"),
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
                      validateFeilds();
                    },
                    decoration: const InputDecoration(
                        labelText: "Server Ip Address",
                        hintText: "e.g 192.168.1.5"),
                  ),
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(fileName),
                        IconButton.filled(
                          onPressed: pickAudioFile,
                          icon: const Icon(
                            Icons.upload_file,
                            // color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // if (audioFile != null)
                  //   ElevatedButton(
                  //     onPressed: () => uploadAudioFile(audioFile!.path),
                  //     child: Text('Send File to Server'),
                  //   ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.cloud_upload),
        onPressed: () async {
          validateFeilds();
          if (audioFile == null) {
            showSnackbar("Please attach the audio file first");
            return;
          }
          if (await uploadAudio()) {
            showSnackbar("Meeting Recording Shared Successfully");
            Navigator.of(context).pushNamed(HomeScreen.routeName);
          } else {
            showSnackbar("Unable to upload meeting recording");
          }
        },
        label: const Text("Upload"),
      ),
    );
  }
}
