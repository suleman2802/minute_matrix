import 'package:flutter/material.dart';
import 'package:minute_matrix/Screens/meeting_detail_screen.dart';

class ListTileWidget extends StatelessWidget {
  String title;
  String duration;
  String time;
  String type;
  String hostName;
  String hostId;

  ListTileWidget(this.title, this.duration, this.time, this.type, this.hostName,
      this.hostId);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () => Navigator.of(context)
              .pushNamed(MeetingDetailScreen.routeName, arguments: {
            "meetingName": title,
            "duration": duration,
            "time": time,
            "meetingType": type,
            "hostName": hostName,
            "hostId": hostId,
          }),
          subtitleTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 14,
              ),
          title: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
          subtitle: Text(
            type,
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          // subtitle: OutlinedButton(
          //   style: OutlinedButton.styleFrom(
          //     maximumSize: Size(10,50),
          //     minimumSize: Size(10,30),
          //   ),
          //   onPressed: null,
          //   child: Text(
          //     "Offline",
          //     //style: Theme.of(context).textTheme.bodySmall,
          //   ),
          // ),
          leading: Icon(
            size: 30,
            Icons.play_circle_fill,
            color: Theme.of(context).primaryColor,
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                time,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              Text(
                duration,
                style: Theme.of(context).textTheme.bodySmall,
                // style: TextStyle(
                //     color: Theme.of(context).primaryColor, fontSize: 12),
              ),
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //    // maximumSize: Size(10,10),
              //   ),
              //   onPressed: () {},
              //   child: Text(
              //     "offline",
              //     //style: TextStyle(color: Theme.of(context).primaryColor,
              //     //fontSize: 12,),
              //   ),
              // ),
            ],
          ),
        ),
        Divider(),
      ],
    );
    // return OutlinedButton.icon(
    //   icon: Icon(
    //     Icons.play_circle_fill_rounded,
    //     color: Theme.of(context).primaryColor,
    //   ),
    //   onPressed: () {},
    //   label: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Text(
    //         "Title",
    //         style: Theme.of(context).textTheme.bodyMedium,
    //       ),
    //       Column(
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         children: [
    //           Text("18/1/2024",style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.w700),),
    //           Text("50:12",style: TextStyle(color: Theme.of(context).primaryColor),),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }
}
