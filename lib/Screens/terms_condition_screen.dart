import 'package:flutter/material.dart';

class TermsConditionScreen extends StatelessWidget {
  static const String routeName = "./termsConditionScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms & Conditions"),
      ),
      body: SingleChildScrollView(
        child: Expanded(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                description(
                    "Welcome to MinuteMatrix (MM), a mobile application designed for iOS and Android platforms. MM aims to enhance the efficiency of online and offline meetings by offering real-time transcription, speaker identification, and other valuable features"),
                space(),
                heading("Acceptance of Terms", context),
                space(),
                description(
                    "By using the MinuteMatrix application, you agree to comply with and be bound by these Terms of Service. If you do not agree with any part of these terms, you may not use the application."),
                space(),
                heading("Description of Service", context),
                space(),
                description("MinuteMatrix provides the following services:"),
                bulletPoint(
                    "Real-time transcription and translation of meetings"),
                bulletPoint(
                    "Identification of speakers and generation of subtitles in multiple languages"),
                bulletPoint("Recording and storage of meeting discussions"),
                bulletPoint(
                    "Generation of detailed Minutes of Meetings documents"),
                bulletPoint(
                    "Automatic summarization of discussions in text and audio formats"),
                bulletPoint(
                    "Note sharing, read-aloud feature, and voice search functionality"),
                space(),
                heading("User Responsibilities", context),
                space(),
                description("Users are expected to :"),
                bulletPoint(
                    "Respect the rights of other users and refrain from posting harmful or offensive content"),
                bulletPoint(
                    "Comply with all applicable laws and regulations while using the application"),
                bulletPoint(
                    "Safeguard their account credentials and use the application responsibly"),
                space(),
                heading("Privacy", context),
                space(),
                description("User data is collected, used, and protected in accordance with our Privacy Policy. By using MinuteMatrix, you consent to the collection and use of your data as described in the Privacy Policy."),
                space(),
                heading("Intellectual Property", context),
                space(),
                description("All content within the MinuteMatrix application, including but not limited to text, graphics, software, and audio recordings, is owned by MinuteMatrix or its licensors and is protected by copyright and other intellectual property laws."),
                space(),
                heading("Limitation of Liability", context),
                space(),
                description("MinuteMatrix is not liable for any direct, indirect, incidental, special, or consequential damages arising from the use of the application. Users utilize the application at their own risk."),
                space(),
                heading("Termination", context),
                space(),
                description("MinuteMatrix reserves the right to terminate any user's access to the application at any time if they violate these Terms of Service or engage in prohibited activities."),
                space(),
                heading("Changes to Terms", context),
                space(),
                description("MinuteMatrix may modify these Terms of Service at any time. Users will be notified of any changes, and continued use of the application constitutes acceptance of the modified terms."),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


  Widget space() {
    return const SizedBox(
      height: 5,
    );
  }


Widget heading(String data, BuildContext context) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(
      data,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
        fontSize: 20,
      ),
    ),
  );
}

Widget bulletPoint(String data) {
  return Text(
    " - $data",
    style: const TextStyle(
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget description(String data) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(
      data,
    ),
  );
}
