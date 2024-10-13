// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

import '../Providers/user_provider.dart';
import './home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/SplashScreen";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void getNecessaryData() async {
    try {
      await Provider.of<UserProvider>(context, listen: false)
          .fetchUserDetails();
      // .then((value) =>
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomeScreen()),
      // );

      // Navigator.of(context).pushNamed(HomeScreen.routeName);
    } catch (error) {
      //Navigator.of(context).pushNamed(AuthScreen.routeName);
    }
    // );
  }
//
//   void requestMessagingPermission() async {
//     // final fbm = FirebaseMessaging.instance;
//     // fbm.requestPermission();
//     final notificationSettings =
//         await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//   }
//   void getMessage(){
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//   print('Got a message whilst in the foreground!');
//   print('Message data: ${message.data}');
//
//   if (message.notification != null) {
//     print('Message also contained a notification: ${message.notification}');
//   }
// });
//   }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNecessaryData();
    //requestMessagingPermission();
    //getMessage();
  }

  @override
  Widget build(BuildContext context) {
    print("splash screen");
    return Scaffold(
      body: FutureBuilder(
        future: Future.delayed(
          const Duration(seconds: 5),
        ),
        builder: (ctx, timer) => AnimatedSplashScreen(
          duration: 2500,
          splash: Image.asset(
            'assets/splash_logo.png',
          ),
          splashIconSize: 700,
          nextScreen: HomeScreen(),
          //splashTransition: SplashTransition.slideTransition,
        ),
      ),
    );
  }
}
