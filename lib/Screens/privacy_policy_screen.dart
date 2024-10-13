import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  static const String routeName = "./privacyPolicyScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Privacy Policies",
        ),
      ),
      body: SingleChildScrollView(
        child: Expanded(
          child: Container(
            margin: const EdgeInsets.all(20),
            //width: MediaQuery.of(context).size.width * 0.88,
            child: Column(
              children: [
                const Text(
                  "MinuteMatrix (MM) is a comprehensive mobile application designed for both iOS and Android platforms, with the primary goal of enhancing the efficiency of online and offline meetings. Leveraging speaker diarization technology, the app excels at identifying speakers and providing real-time subtitles during meetings. It serves as a valuable tool by recording discussions in both audio and text format and generating a detailed Minutes of Meetings document, including essential details such as Date, Time, Attendees, Host, Purpose, and Agenda. Noteworthy features of MinuteMatrix include automatic summarization of entire discussions in both text and audio formats, facilitating efficient review. The meeting host can share meeting notes with colleagues via email and utilize the read-aloud feature for enhanced accessibility. Additionally, the implementation of voice search functionality enhances the overall search experience within the application.",
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "What Information We Collect",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "MinuteMatrix collects various types of information to provide and improve its services, including:",
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      " - Audio recordings of meetings",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " - Transcriptions and translations of meetings",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " - User account information (such as name and contact details)",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "How We Use Your Information",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("We use the collected information to:"),
                    Text(
                      " - Provide real-time transcription and translation services during meetings",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " - Identify speakers and generate subtitles during meeting recordings",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " - Record meeting discussions in both audio and text format",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " - Generate Minutes of Meetings documents with essential details",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " - Automatically summarize entire discussions in text and audio formats",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " - Facilitate note sharing among meeting participants",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " - Provide a read-aloud feature for enhanced accessibility",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " - Implement voice search functionality for efficient information retrieval",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "How We Share Your Information",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "MinuteMatrix may share user information in the following circumstances:"),
                    Text(
                      " - When meeting hosts share meeting notes with participants",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " - To comply with legal obligations or to protect and defend our rights",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " - With service providers who assist us in providing the services",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Changes in Policy",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                    ),
                  ),
                ),
                Text(
                    "Let's us know if you want to genrate MOM Document according to your organization standards"),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "We may update this Privacy Policy from time to time. Any changes will be posted on our website or within the MinuteMatrix application, and we may also notify users via email or other means.",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
