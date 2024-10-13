import 'package:flutter/material.dart';

class SubscriptionPlanWidget extends StatelessWidget {
  bool isStandard;
  SubscriptionPlanWidget(this.isStandard);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //width: MediaQuery.of(context).size.width * 0.88,
      child: Card(
        margin: EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            children: [
              Row(
                children: [
                  Text(isStandard ? "Standard" : "Enterprise",
                      style: Theme.of(context).textTheme.displayLarge),
                  SizedBox(
                    width: 15,
                  ),
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).primaryColor,
                    size: 30,
                  ),
                ],
              ),
              Text(isStandard
                  ? "Ideal for individuals starting with MinuteMatrix"
                  : "Ultimate Plan for organizations , fast growing business"),
              Row(
                children: [
                  Text(
                    "\$",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    isStandard ? "0" : "69.99",
                    style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(isStandard ? "Free forever" : "only"),
                ],
              ),
              Divider(),
              SingleItemWidget(" ${isStandard? "20":"45"}    Meeting Credits"),
              SingleItemWidget("${isStandard? "300":"650"}   Total Meeting Hours"),
              SingleItemWidget(" ${isStandard? "15":"30"}    Offline Meeting Recording"),
              SingleItemWidget(" ${isStandard? "5":"15"}      Upload Meeting Recording"),
              Divider(),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Key features",
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontSize: 22,
                      ),
                ),
              ),
              const SizedBox(height: 5,),
              SingleItemWidget("Meeting Collaboration"),
              SingleItemWidget("Transcription for 5 languages"),
              SingleItemWidget("Dialogue Translation"),
              SingleItemWidget("Search within meeting"),
              SingleItemWidget("Generate meeting topics"),
              SingleItemWidget("Genrate Meeting Summary"),
              // SingleItemWidget("Download Meeting Summary"),
              SingleItemWidget("Minute of Meeting Document"),
              !isStandard?SingleItemWidget("Meeting Collaboration"):SizedBox(),
              !isStandard?SingleItemWidget("Meeting notes sharing"):SizedBox(),
              // !isStandard?SingleItemWidget("Automatic Email notification"):SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class SingleItemWidget extends StatelessWidget {
  String text;
  SingleItemWidget(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.check,
          color: Theme.of(context).primaryColor,
        ),
        SizedBox(
          width: 8,
        ),
        Text(text),
      ],
    );
  }
}
