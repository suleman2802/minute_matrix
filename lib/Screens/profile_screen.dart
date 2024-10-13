import 'package:flutter/material.dart';
import '../widgets/profile/dark_theme_toggle_widget.dart';
import 'package:provider/provider.dart';

import '../widgets/profile/general_widget.dart';
import '../widgets/drawer/drawer_widget.dart';
import '../widgets/profile/about_app_widget.dart';
import '../widgets/profile/upload_pic.dart';
import '../Providers/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = "/profile";

  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserProvider>(context).userDetails;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: Icon(Icons.settings),
        //   ),
        // ],
      ),
      drawer: DrawerWidget(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          //child: Card(
          //elevation: 10,
          child: Center(
            child: Column(
              children: [
                UploadPic(),
                SizedBox(
                  height: 5,
                ),
                Text(
                  userDetails.getName(),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(userDetails.getEmail()),
                GeneralWidget(),
                DarkThemeToggleWidget(),
                SizedBox(
                  height: 10,
                ),
                AboutAppWidget(),
              ],
            ),
          ),
          // ),
        ),
      ),
    );
  }
}
