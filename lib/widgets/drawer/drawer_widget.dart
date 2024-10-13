import 'package:flutter/material.dart';
import 'package:minute_matrix/Screens/check.dart';
import 'package:minute_matrix/Screens/view_meeting_list_screen.dart';
import 'package:provider/provider.dart';

import '../../Screens/join_offline_meeting_screen.dart';
import '../../Screens/subscription_plans_screen.dart';
import '../../Screens/subscription_usage_Screen.dart';
import '../../Providers/user_auth_provider.dart';
import '../../Providers/user_provider.dart';
import '../../Screens/home_screen.dart';
import '../../Screens/profile_screen.dart';
import '../profile/profile_pic.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  int _selectedIndex = 0;
  // static const TextStyle optionStyle =
  //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  // static const List<Widget> _widgetOptions = <Widget>[
  //   Text(
  //     'Index 0: Home',
  //     style: optionStyle,
  //   ),
  //   Text(
  //     'Index 1: Business',
  //     style: optionStyle,
  //   ),
  //   Text(
  //     'Index 2: School',
  //     style: optionStyle,
  //   ),
  // ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserProvider>(context).userDetails;
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: 80,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ProfilePic(),
                  SizedBox(
                    width: 12,
                  ),
                  // FutureBuilder(
                  //   future: Provider.of<UserProvider>(context,listen: false).username(),
                  //   builder:(context,snapshot)=> Text(
                  //    snapshot.hasData? snapshot.data.toString() : "Loading..",
                  //     style: Theme.of(context).textTheme.titleLarge,
                  //   ),
                  // ),
                  Text(
                    userDetails.getName(),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: const Text('Dashboard'),
            selected: _selectedIndex == 0,
            onTap: () {
              // Update the state of the app
              //_onItemTapped(0);
              // Then close the drawer
              Navigator.of(context).pushNamed(HomeScreen.routeName);
            },
          ),
          ListTile(
            title: const Text('Record Meeting'),
            //selected: _selectedIndex == 1,
            onTap: () {
              // Update the state of the app
              //_onItemTapped(1);
              // Then close the drawer
              Navigator.of(context).pushNamed(HomeScreen.routeName);
            },
          ),
          // ListTile(
          //   title: const Text('Join Offline Meeting'),
          //   //selected: _selectedIndex == 1,
          //   onTap: () {
          //     // Update the state of the app
          //     //_onItemTapped(1);
          //     // Then close the drawer
          //     Navigator.of(context).pushNamed(JoinOfflineMeetingScreen.routeName);
          //   },
          // ),
          ListTile(
            title: const Text('View Recorded Meetings'),
            //selected: _selectedIndex == 1,
            onTap: () {
              // Update the state of the app
              //_onItemTapped(1);
              // Then close the drawer
              Navigator.of(context).pushNamed(ViewMeetingListScreen.routeName);
            },
          ),
          ListTile(
            title: const Text('Subscription Usage Details'),
            //selected: _selectedIndex == 2,
            onTap: () {
              // Update the state of the app
              // _onItemTapped(2);
              // Then close the drawer
              Navigator.of(context)
                  .pushNamed(SubscriptionUsageScreen.routeName);
            },
          ),
          ListTile(
            title: const Text('Subscription Plans'),
            //selected: _selectedIndex == 2,
            onTap: () {
              // Update the state of the app
              // _onItemTapped(2);
              // Then close the drawer
              // Navigator.pop(context);
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return Check();
              // }));
              Navigator.of(context).pushNamed(SubscriptionPlansScreen.routeName);
            },
          ),
          ListTile(
            title: const Text('Profile'),
            //selected: _selectedIndex == 2,
            onTap: () {
              // Update the state of the app
              // _onItemTapped(2);
              // Then close the drawer
              Navigator.of(context).pushNamed(ProfileScreen.routeName);
            },
          ),
          ListTile(
            title: const Text('Logout'),
            //selected: _selectedIndex == 2,
            onTap: () async {
              // Update the state of the app
              // _onItemTapped(2);
              // Then close the drawer
              await Provider.of<UserAuthProvider>(context, listen: false)
                  .logout();
              // .then((value) => setState(() {
              Navigator.pushNamed(context, "/");
              // }));
            },
          ),
          //SizedBox(height: 100,),
          //FittedBox(child: MinuteConsumedWidget()),
        ],
      ),
    );
  }
}
