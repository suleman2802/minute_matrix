import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';

class Check extends StatefulWidget {
  @override
  _CheckState createState() => _CheckState();
}

class _CheckState extends State<Check> {
  File? _file;

  Future pickFile() async {
    final pickedFile = await FilePicker.platform.pickFiles();
    setState(() {
      _file = File(pickedFile!.files.single.path!);
    });
  }

  Future uploadFile() async {
    final Reference storageReference =
        FirebaseStorage.instance.ref().child('uploads/}');
    final UploadTask uploadTask = storageReference.putFile(_file!);
    await uploadTask.whenComplete(() => print('File Uploaded'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Picker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: pickFile,
              child: const Text('Pick File'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: uploadFile,
              child: const Text('Upload File'),
            ),
          ],
        ),
      ),
    );
  }
}
