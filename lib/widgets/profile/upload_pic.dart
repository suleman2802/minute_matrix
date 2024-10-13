import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minute_matrix/widgets/profile/dark_theme_toggle_widget.dart';
import 'package:provider/provider.dart';
import '../../Providers/user_provider.dart';

class UploadPic extends StatefulWidget {
  //final _userId;
  // ProfilePic(this._userId);
  @override
  State<UploadPic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<UploadPic> {
  File? _imgFile;
  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final ImagePicker picker = ImagePicker();
    final XFile? img = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (img == null) return;
    setState(() {
      _imgFile = File(img.path);
    });
    bool uploadResult = await userProvider.uploadImage(_imgFile);
    await userProvider.fetchUserDetails();
    if (uploadResult) {
      showSnackBar("Profile Image Uploaded Successfully..");
    } else {
      showSnackBar("Image Update Failed, Try again later..");
    }
  }

  NetworkImage checkImage(var imageUrl) {
    if (imageUrl.hasData) {
      return NetworkImage(imageUrl.data!);
    }
    return NetworkImage(
        "https://images.unsplash.com/photo-1544502062-f82887f03d1c?q=80&w=3359&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<UserProvider>(context).getImageUrl(),
      builder: (context, imageUrl) {
        return Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 3),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: DarkThemeToggleWidget.isDarkMode
                              ? Colors.black
                              : Colors.white,
                          width: 4),
                      shape: BoxShape.circle,
                    ),
                    child: FittedBox(
                      child: CircleAvatar(
                        radius: 60,
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        backgroundImage: _imgFile != null
                            ? FileImage(_imgFile!)
                            : checkImage(imageUrl) as ImageProvider,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 8,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: InkWell(
                      child: Icon(Icons.edit, color: Colors.white, size: 18),
                      onTap: () => _pickImage(context),
                    ),
                  ),
                ),
              ],
            ),
            // SizedBox(
            //   height: 8,
            // ),
            // OutlinedButton.icon(
            //   onPressed: () => _pickImage(context),
            //   icon: Icon(Icons.edit),
            //   label: Text("Change Profile image"),
            // ),
          ],
        );
      },
    );
  }
}



            



            //              FittedBox(
            //   child: CircleAvatar(
            //     radius: 60,
            //     foregroundColor: Colors.black,
            //     backgroundColor: Colors.white,
            //     backgroundImage: _imgFile != null
            //         ? FileImage(_imgFile!)
            //         : checkImage(imageUrl) as ImageProvider,
            //   ),
            // ),