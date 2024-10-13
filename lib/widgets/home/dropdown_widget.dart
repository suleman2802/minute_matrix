import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Screens/profile_screen.dart';

class dropdownWidget extends StatelessWidget {
  const dropdownWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      dropdownColor: Colors.white,
      items: [
        DropdownMenuItem(
          value: "logout",
          child: SizedBox(
            child: Row(
              children: [
                Icon(
                  Icons.exit_to_app,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text(
                  "Log out",
                ),
              ],
            ),
          ),
        ),
        DropdownMenuItem(
          value: "profile",
          child: SizedBox(
            child: Row(
              children: [
                Icon(
                  Icons.portrait,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text(
                  "Profile",
                ),
              ],
            ),
          ),
        ),
      ],
      onChanged: (itemIdentifier) {
        if (itemIdentifier == "logout") {
          FirebaseAuth.instance.signOut();
          Navigator.pushNamed(context, "/");
        }
        if (itemIdentifier == "profile") {
          Navigator.pushNamed(context, ProfileScreen.routeName);
        }
      },
      icon: Icon(
        Icons.more_vert,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
