import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  static const String routeName = "./aboutApp";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About App"),
      ),
      body: SingleChildScrollView(
        child: Expanded(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "App Version : ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                      ),
                    ),
                    const Text(
                      "1.0.1",
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "MinuteMatrix (MM) is like your personal meeting assistant right on your phone. It's designed to simplify your meetings by transcribing conversations in real time, identifying speakers, and even translating languages if needed. Imagine having a note-taker that never misses a word!With MM, you can effortlessly capture every moment of your meetings by recording them with just a tap. After the meeting, MM helps you create concise summaries of what was discussed, making it easy to remember key points and action items. And when it's time to collaborate with your team, MM allows you to share meeting notes seamlessly.But that's not all! MM comes with some pretty cool features too. It can automatically summarize lengthy discussions, read out loud to you for accessibility, and even let you search through your recordings using just your voice. It's like having a supercharged assistant right in your pocket, ready to make your meetings more productive and efficient",
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Developer Information",
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
                const Row(
                  children: [
                    Text(
                      "App Name : ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "MinuteMatrix",
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Text(
                      "Developer Name : ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "MinuteMatrix Group",
                    ),
                  ],
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Contact Information",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Row(
                  children: [
                    Text(
                      "Email : ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "minutematrix@outlook.com",
                    ),
                  ],
                ),
                Text(
                    "Let's us know if you want to genrate MOM Document according to your organization standards"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
