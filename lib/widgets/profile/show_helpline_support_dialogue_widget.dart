import 'package:flutter/material.dart';
class ShowHelplineSupportDialogue extends StatelessWidget {
  bool isSupport;
  ShowHelplineSupportDialogue(this.isSupport);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 250,
        child: AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text( isSupport? "Help & Support" : "Helpline Number",style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),),
          content: Column(
            children: [
              Text("Feel Free to contact us, on ${isSupport? "support email" : "helpline number"}, if ou have any query"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(isSupport? Icons.email_outlined : Icons.phone_forwarded_outlined , color: Theme.of(context).primaryColor,),
                  Text(
                    isSupport? "minutematrix@outlook.com" : "+92-300-1234567",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
          ],
        ),
        ),
      ),
    );
  }
}
