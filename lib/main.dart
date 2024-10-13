import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:minute_matrix/Screens/meeting_detail_screen.dart';
import 'package:provider/provider.dart';

// import 'package:firebase_app_check/firebase_app_check.dart';
//import 'package:dcdg/dcdg.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../Providers/user_auth_provider.dart';
import '../Screens/splash_screen.dart';
import '../widgets/profile/dark_theme_toggle_widget.dart';
import '../Providers/user_provider.dart';
import '../widgets/theme/theme_widget.dart';
import '../Screens/forget_password_screen.dart';
import '../Screens/auth_screen.dart';
import '../Screens/home_screen.dart';
import '../Screens/profile_screen.dart';
import '../Screens/change_username_screen.dart';
import '../Screens/change_password_screen.dart';
import '../Screens/subscription_usage_screen.dart';
import '../Screens/subscription_plans_screen.dart';
import '../Screens/view_meeting_list_screen.dart';
import '../Screens/record_offline_meeting_screen.dart';
import '../Screens/join_offline_meeting_screen.dart';
import '../Screens/record_online_meeting.dart';
import '../Screens/recording_offline_meeting_screen.dart';
import '../Screens/payment_screen.dart';
import '../Screens/about_app_screen.dart';
import '../Screens/privacy_policy_screen.dart';
import '../Screens/terms_condition_screen.dart';
import 'Screens/demo_recording_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    /// FireBase Initialization
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // await FirebaseAppCheck.instance.activate(
    //   // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
    //   // argument for `webProvider`
    //   webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    //   // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    //   // your preferred provider. Choose from:
    //   // 1. Debug provider
    //   // 2. Safety Net provider
    //   // 3. Play Integrity provider
    //   androidProvider: AndroidProvider.debug,
    //   // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
    //   // your preferred provider. Choose from:
    //   // 1. Debug provider
    //   // 2. Device Check provider
    //   // 3. App Attest provider
    //   // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    //   appleProvider: AppleProvider.appAttest,
    // );
    print(" Firebase instance => inside try");
  } catch (error) {
    print("Inside catch");
    print("Firebase instance Error : " + error.toString());
  }

  //Assign publishable key to flutter_stripe
  Stripe.publishableKey =
      "pk_test_51Op1bALEEUvK32syjxHcJciobRTjdjgwjLzCoxoev9WVwFh4Bj8hgqFQr5Jt4Uj2Lc3HmkT0x6wRkiS97GkIWD1q00AioA3p8Y";

  //Load our .env file that contains our Stripe Secret key
  await dotenv.load(fileName: "assets/.env");
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  await getModeDetail();
  runApp(MyApp(savedThemeMode));
}

Future<void> getModeDetail() async {
  final result = await AdaptiveTheme.getThemeMode();

  if (result == AdaptiveThemeMode.dark) {
    DarkThemeToggleWidget.isDarkMode = true;
  } else {
    DarkThemeToggleWidget.isDarkMode = false;
  }
}

class MyApp extends StatelessWidget {
  final savedThemeMode;

  MyApp(this.savedThemeMode);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider<UserAuthProvider>(
          create: (context) => UserAuthProvider(),
        ),
      ],
      child: AdaptiveTheme(
        light: ThemeWidget.lightTheme,
        dark: ThemeWidget.darkTheme,
        initial: savedThemeMode ?? AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: theme,
          darkTheme: darkTheme,
          routes: {
            HomeScreen.routeName: (context) => HomeScreen(),
            SplashScreen.routeName: (context) => SplashScreen(),
            AuthScreen.routeName: (context) => AuthScreen(),
            ForgetPasswordScreen.routeName: (context) => ForgetPasswordScreen(),
            ProfileScreen.routeName: (context) => ProfileScreen(),
            ChangeUsernameScreen.routeName: (context) => ChangeUsernameScreen(),
            ChangePasswordScreen.routeName: (context) => ChangePasswordScreen(),
            SubscriptionUsageScreen.routeName: (context) =>
                SubscriptionUsageScreen(),
            SubscriptionPlansScreen.routeName: (context) =>
                SubscriptionPlansScreen(),
            ViewMeetingListScreen.routeName: (context) =>
                ViewMeetingListScreen(),
            RecordOfflineMeetingScreen.routeName: (context) =>
                RecordOfflineMeetingScreen(),
            RecordOnlineMeetingScreen.routeName: (context) =>
                RecordOnlineMeetingScreen(),
            JoinOfflineMeetingScreen.routeName: (context) =>
                JoinOfflineMeetingScreen(),
            RecordingOfflineMeetingScreen.routeName: (context) =>
                RecordingOfflineMeetingScreen(),
            PaymentScreen.routeName: (context) => PaymentScreen(),
            AboutAppScreen.routeName: (context) => AboutAppScreen(),
            PrivacyPolicyScreen.routeName: (context) => PrivacyPolicyScreen(),
            TermsConditionScreen.routeName: (context) => TermsConditionScreen(),
            MeetingDetailScreen.routeName: (context) => MeetingDetailScreen(),
            DemoRecordingScreen.routeName: (context) => DemoRecordingScreen(),
          },
          //initialRoute: SplashScreen.routeName,
          home: //MeetingDetailScreen(),
              StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, userSnapShot) {
              if (userSnapShot.hasData) {
                // return HomeScreen();
                return SplashScreen();
              } else {
                //user is currently signed out or token is expired
                return AuthScreen();
              }
            },
          ),
        ),
      ),
    );
  }
}
// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_email_sender/flutter_email_sender.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(primaryColor: Colors.red),
//       home: EmailSender(),
//     );
//   }
// }
//
// class EmailSender extends StatefulWidget {
//   const EmailSender({Key? key}) : super(key: key);
//
//   @override
//   _EmailSenderState createState() => _EmailSenderState();
// }
//
// class _EmailSenderState extends State<EmailSender> {
//   List<String> attachments = [];
//   bool isHTML = false;
//
//   final _recipientController = TextEditingController(
//     text: 'example@example.com',
//   );
//
//   final _subjectController = TextEditingController(text: 'The subject');
//
//   final _bodyController = TextEditingController(
//     text: 'Mail body.',
//   );
//
//   Future<void> send() async {
//     final Email email = Email(
//       body: _bodyController.text,
//       subject: _subjectController.text,
//       recipients: [_recipientController.text],
//       attachmentPaths: attachments,
//       isHTML: isHTML,
//     );
//
//     String platformResponse;
//
//     try {
//       await FlutterEmailSender.send(email);
//       platformResponse = 'success';
//     } catch (error) {
//       print(error);
//       platformResponse = error.toString();
//     }
//
//     if (!mounted) return;
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(platformResponse),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Plugin example app'),
//         actions: <Widget>[
//           IconButton(
//             onPressed: send,
//             icon: Icon(Icons.send),
//           )
//         ],
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(8.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Padding(
//               padding: EdgeInsets.all(8.0),
//               child: TextField(
//                 controller: _recipientController,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: 'Recipient',
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.all(8.0),
//               child: TextField(
//                 controller: _subjectController,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: 'Subject',
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: TextField(
//                   controller: _bodyController,
//                   maxLines: null,
//                   expands: true,
//                   textAlignVertical: TextAlignVertical.top,
//                   decoration: InputDecoration(
//                       labelText: 'Body', border: OutlineInputBorder()),
//                 ),
//               ),
//             ),
//             CheckboxListTile(
//               contentPadding:
//               EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
//               title: Text('HTML'),
//               onChanged: (bool? value) {
//                 if (value != null) {
//                   setState(() {
//                     isHTML = value;
//                   });
//                 }
//               },
//               value: isHTML,
//             ),
//             Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Column(
//                 children: <Widget>[
//                   for (var i = 0; i < attachments.length; i++)
//                     Row(
//                       children: <Widget>[
//                         Expanded(
//                           child: Text(
//                             attachments[i],
//                             softWrap: false,
//                             overflow: TextOverflow.fade,
//                           ),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.remove_circle),
//                           onPressed: () => {_removeAttachment(i)},
//                         )
//                       ],
//                     ),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: IconButton(
//                       icon: Icon(Icons.attach_file),
//                       onPressed: _openImagePicker,
//                     ),
//                   ),
//                   TextButton(
//                     child: Text('Attach file in app documents directory'),
//                     onPressed: () => _attachFileFromAppDocumentsDirectoy(),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _openImagePicker() async {
//     final picker = ImagePicker();
//     final pick = await picker.pickImage(source: ImageSource.gallery);
//     if (pick != null) {
//       setState(() {
//         attachments.add(pick.path);
//       });
//     }
//   }
//
//   void _removeAttachment(int index) {
//     setState(() {
//       attachments.removeAt(index);
//     });
//   }
//
//   Future<void> _attachFileFromAppDocumentsDirectoy() async {
//     try {
//       final appDocumentDir = await getApplicationDocumentsDirectory();
//       final filePath = appDocumentDir.path + '/file.txt';
//       final file = File(filePath);
//       await file.writeAsString('Text file in app directory');
//
//       setState(() {
//         attachments.add(filePath);
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to create file in applicion directory'),
//         ),
//       );
//     }
//   }
// }