import 'package:flutter/material.dart';
import 'package:minute_matrix/Providers/user_provider.dart';
import 'package:minute_matrix/Screens/profile_screen.dart';
import 'package:provider/provider.dart';

class ProfilePic extends StatelessWidget {
  // String _imageUrl = "";
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, ProfileScreen.routeName),
      // child: FutureBuilder(
      //     future: Provider.of<UserProvider>(context).getImageUrl(),
      //     builder: (context, imageUrl) {
      //       return FittedBox(
      //         child: CircleAvatar(
      //           radius: 25,
      //           backgroundImage:
      //               imageUrl.hasData ? NetworkImage(imageUrl.data!) : null,
      //           backgroundColor: Colors.white,
      //         ),
      //       );
      //     }),
      child: Consumer<UserProvider>(
        builder: (context, value, child) => FittedBox(
          child: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(value.userDetails.getUrl()),
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
//"https://img.freepik.com/premium-vector/account-icon-user-icon-vector-graphics_292645-552.jpg?w=1380"