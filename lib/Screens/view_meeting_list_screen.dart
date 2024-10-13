import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minute_matrix/Providers/user_provider.dart';
import 'package:minute_matrix/widgets/general/list_tile_widget.dart';
import 'package:minute_matrix/widgets/view_meeting_list/meeting_list_widget.dart';
import 'package:minute_matrix/widgets/view_meeting_list/search_bar_widget.dart';
import 'package:provider/provider.dart';

import '../Models/latest_meeting.dart';

class ViewMeetingListScreen extends StatefulWidget {
  static const String routeName = "/viewMeetingList";

  @override
  State<ViewMeetingListScreen> createState() => _ViewMeetingListScreenState();
}

class _ViewMeetingListScreenState extends State<ViewMeetingListScreen> {
  var list = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  // String message = "No Record Entered yet";

  List<LatestMeeting> offlineMeeting = [];
  List<LatestMeeting> uploadMeeting = [];
  List<LatestMeeting>? _tempofflineMeeting;
  List<LatestMeeting>? _tempuploadMeeting;
  bool? canReload;
  bool? isOfflineActive;

  // bool? saveTemp;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    canReload = true;
    isOfflineActive = true;
    // saveTemp = true;
  }

  void _filterMeetingName(String query) {
    // if (saveTemp!) {
    //   print("inside temp");
    //   _tempofflineMeeting = offlineMeeting;
    //   _tempuploadMeeting = uploadMeeting;
    // }
    if (query.isEmpty) {
      print("inside  empty");
      setState(() {
        offlineMeeting = _tempofflineMeeting!;
        uploadMeeting = _tempuploadMeeting!;
        // saveTemp = true;
      });
    } else {
      // saveTemp = false;
      setState(() {
        offlineMeeting = offlineMeeting
            .where((LatestMeeting) => LatestMeeting.meetingName
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
        uploadMeeting = uploadMeeting
            .where((LatestMeeting) => LatestMeeting.meetingName
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  // activeOffline() {
  //   setState(() {
  //     isOfflineActive = true;
  //   });
  // }
  //
  // activeUpload() {
  //   setState(() {
  //     isOfflineActive = false;
  //   });
  // }

  // void searchItem() {
  //   //bool found = list.contains(name);
  //   //if(found){
  //
  //   final itemFound = list
  //       .where((element) =>
  //           element.name.toString().toLowerCase() ==
  //           searchController.text!.toLowerCase())
  //       .toList();
  //   if (itemFound.isNotEmpty) {
  //     setState(() {
  //       searchController.clear();
  //       list = itemFound;
  //     });
  //     print("found ---------------------------------------");
  //     showSnackBar("Entry Found....");
  //   } else if (searchController.text.isEmpty) {
  //     showSnackBar("Enter text to search!....");
  //   } else {
  //     showSnackBar("No Entry of ${searchController.text} found!...");
  //   }
  // }

  void _StartDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      } else {
        try {
          final endFilterListOffline = offlineMeeting.where((element) {
            DateFormat dateFormat = DateFormat("dd/MM/yyyy");
            DateTime tempDate = dateFormat.parse(element.time);

            //final date = DateFormat("yyyy-MM-dd").format(tempDate);
            //tempDate = DateTime.parse(date);

            if (tempDate.isBefore(pickedDate)) {
              return true;
            } else {
              return false;
            }
          }).toList();
          final endFilterListUpload = uploadMeeting.where((element) {
            DateFormat dateFormat = DateFormat("dd/MM/yyyy");
            DateTime tempDate = dateFormat.parse(element.time);

            //final date = DateFormat("yyyy-MM-dd").format(tempDate);
            //tempDate = DateTime.parse(date);

            if (tempDate.isAfter(pickedDate)) {
              return true;
            } else {
              return false;
            }
          }).toList();

          setState(() {
            // if(endFilterList.isNotEmpty) {
            offlineMeeting = endFilterListOffline;
            uploadMeeting = endFilterListUpload;
            // message = "No Match Entry found!...";
            //  }
            _selectedStartDate = pickedDate;
          });
          showSnackBar("Start Date Filter Applied Successfully");
        } catch (error) {
          print("Start Error : " + error.toString());
          showSnackBar("Start Date Filter failed Try again later");
        }
      }
    });
  }

  void _EndDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      } else {
        try {
          // saveTemp = false;
          final endFilterListOffline = offlineMeeting.where((element) {
            DateFormat dateFormat = DateFormat("dd/MM/yyyy");
            DateTime tempDate = dateFormat.parse(element.time);

            //final date = DateFormat("yyyy-MM-dd").format(tempDate);
            //tempDate = DateTime.parse(date);

            if (tempDate.isBefore(pickedDate)) {
              return true;
            } else {
              return false;
            }
          }).toList();
          final endFilterListUpload = uploadMeeting.where((element) {
            DateFormat dateFormat = DateFormat("dd/MM/yyyy");
            DateTime tempDate = dateFormat.parse(element.time);

            //final date = DateFormat("yyyy-MM-dd").format(tempDate);
            //tempDate = DateTime.parse(date);

            if (tempDate.isBefore(pickedDate)) {
              return true;
            } else {
              return false;
            }
          }).toList();

          setState(() {
            // if(endFilterList.isNotEmpty) {
            offlineMeeting = endFilterListOffline;
            uploadMeeting = endFilterListUpload;
            // message = "No Match Entry found!...";
            //  }
            _selectedEndDate = pickedDate;
          });
          showSnackBar("End Date Filter Applied Successfully");
        } catch (error) {
          print("Start Error : " + error.toString());
          showSnackBar("End Date Filter failed Try again later");
        }
      }
    });
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
      ),
    );
  }

  getMeetingLists() async {
    List<LatestMeeting> offlineMeetingR =
        await Provider.of<UserProvider>(context, listen: false)
            .fetchMeetings(true);
    // setState(() {
    //   offlineMeeting = offlineMeetingR;
    // });
    List<LatestMeeting> uploadMeetingR =
        await Provider.of<UserProvider>(context, listen: false)
            .fetchMeetings(false);
    setState(() {
      offlineMeeting = offlineMeetingR;
      uploadMeeting = uploadMeetingR;
      _tempofflineMeeting = offlineMeetingR;
      _tempuploadMeeting = uploadMeetingR;
      canReload = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recorded Meeting List"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Theme.of(context).appBarTheme.backgroundColor,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: SearchBar(
                  onTap: () {
                    setState(() {
                      canReload = false;
                    });
                  },
                  controller: searchController,
                  hintText: "Search by meeting name",
                  onChanged: (value) {
                    setState(() {
                      canReload = false;
                    });
                    _filterMeetingName(value);
                  },
                  leading: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => _filterMeetingName(""),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      _selectedStartDate == null
                          ? 'Start Date'
                          : DateFormat("yyyy-MM-dd")
                              .format(_selectedStartDate!),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.calendar_month,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: _StartDatePicker)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      _selectedEndDate == null
                          ? 'End Date'
                          : DateFormat("yyyy-MM-dd").format(_selectedEndDate!),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.calendar_month,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: _EndDatePicker)
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // var reset = [];
                    // widget.isHome
                    //     ? reset =
                    //     Provider
                    //         .of<HomeProvider>(context, listen: false)
                    //         .homeExpense
                    //     : list =
                    //     Provider
                    //         .of<VehicleProvide>(context, listen: false)
                    //         .VehicleExpense;
                    // setState(() {
                    //   list = reset;
                    //   type = "All";
                    setState(() {
                      _selectedStartDate = null;
                      _selectedEndDate = null;
                      searchController.text = "";
                      _filterMeetingName("");
                    });
                    // _selectedStartDate = null;
                    //_selectedEndDate = null;
                    // searchController.text = "";
                    // _filterMeetingName("");
                    // });
                  },
                  label: const Text("Reset"),
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            //ItemHeading(isOnline? "Online Recorded Meetings ":"Offline Recorded Meetings "),
            //MeetingListWidget(true),
            //MeetingListWidget(false),
            const SizedBox(
              height: 8,
            ),
            FutureBuilder(
              future: canReload! ? getMeetingLists() : null,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return const Text("Unable to load meeting record");
                }
                return _tabSection(
                  context,
                  offlineMeeting,
                  uploadMeeting,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _tabSection(BuildContext context, List<LatestMeeting> offlineMeeting,
    List<LatestMeeting> uploadMeeting) {
  return DefaultTabController(
    length: 2,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const TabBar(tabs: [
          Tab(text: "Offline Meetings"),
          Tab(text: "Upload Meetings"),
        ]),
        Container(
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TabBarView(children: [
              offlineMeeting.isNotEmpty
                  ? ListView.builder(
                      itemCount: offlineMeeting.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTileWidget(
                          offlineMeeting[index].meetingName,
                          offlineMeeting[index].duration,
                          offlineMeeting[index].time,
                          offlineMeeting[index].type,
                          offlineMeeting[index].hostName,
                          offlineMeeting[index].hostId,
                        );
                      },
                    )
                  : const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                          "There is no Offline meeting record,Add meeting first "),
                    ),
              uploadMeeting.isNotEmpty
                  ? ListView.builder(
                      itemCount: uploadMeeting.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTileWidget(
                          uploadMeeting[index].meetingName,
                          uploadMeeting[index].duration,
                          uploadMeeting[index].time,
                          uploadMeeting[index].type,
                          uploadMeeting[index].hostName,
                          uploadMeeting[index].hostId,
                        );
                      },
                    )
                  : const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                          "There is no Upload meeting record,Upload meeting first "),
                    ),
            ]),
          ),
        ),
      ],
    ),
  );
}
