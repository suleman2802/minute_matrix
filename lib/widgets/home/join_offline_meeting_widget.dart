import 'package:flutter/material.dart';
import 'package:minute_matrix/Providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../../Screens/join_offline_meeting_screen.dart';

class JoinOfflineMeetingWidget extends StatefulWidget {
  const JoinOfflineMeetingWidget({super.key});

  @override
  State<JoinOfflineMeetingWidget> createState() =>
      _JoinOfflineMeetingWidgetState();
}

class _JoinOfflineMeetingWidgetState extends State<JoinOfflineMeetingWidget> {
  final TextEditingController codeController = TextEditingController();

  showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  bool isNumeric(String str) {
    RegExp _numeric = RegExp(r'^-?[0-9]+$');
    return _numeric.hasMatch(str);
  }

  CodeDialogue() {
    return AlertDialog(
      title: Text("Join Meeting by code"),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            if (codeController.text.length == 4) {
              String result =
                  await Provider.of<UserProvider>(context, listen: false)
                      .joinMeetingByCode(int.parse(codeController.text.trim()));
              showSnackBar(result);
              Navigator.of(context).pop();
            } else if (!isNumeric(codeController.text.trim())) {
              showSnackBar("Enter Valid coupon code of length 4 in digits");
              Navigator.of(context).pop();
            } else {
              showSnackBar("Enter Valid coupon code of length 4");
              Navigator.of(context).pop();
            }
          },
          child: Text("Join"),
        ),
      ],
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: codeController,
          decoration: const InputDecoration(
            hintText: "1234",
          ),
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    codeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          color: Theme.of(context).cardColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                "Join Meeting",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                //child: SingleItem(Icons.qr_code, "Join Offline Meeting"),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.qr_code),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    onPressed: () => Navigator.of(context)
                        .pushNamed(JoinOfflineMeetingScreen.routeName),
                    label: const Text(
                      "Join Meeting by Scan",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                //child: SingleItem(Icons.qr_code, "Join Offline Meeting"),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.qr_code),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => CodeDialogue(),
                    ),
                    label: const Text(
                      "Join Meeting by code",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
