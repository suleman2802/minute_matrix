import 'package:flutter/material.dart';

import '../widgets/join_offline_meeting/qr_scanner_widget.dart';
class JoinOfflineMeetingScreen extends StatefulWidget {
  static const String routeName = "./joinOfflineMeetingScreen";
  const JoinOfflineMeetingScreen({super.key});

  @override
  State<JoinOfflineMeetingScreen> createState() => _JoinOfflineMeetingScreenState();
}

class _JoinOfflineMeetingScreenState extends State<JoinOfflineMeetingScreen> {
  bool isScanComplete = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Join Offline Meeting"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Scan Qr Code",style: Theme.of(context).textTheme.displayLarge,),
                SizedBox(height: 4,),
                Text("To join the offline meeting please scan the Qr code "),
              ],
            ),),
            Expanded(flex: 3,child: QrScannerWidget(),),
            SizedBox(height: 10,),
            Expanded(child: Text("PLease try to keep your camera stable",),),
          ],
        ),
      ),
    );
  }
}
