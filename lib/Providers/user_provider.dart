import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:minute_matrix/Models/Transcription.dart';
import 'package:http/http.dart' as https;
import 'package:http_parser/http_parser.dart';
import '../Models/UserDetails.dart';
import '../Models/latest_meeting.dart';

class UserProvider with ChangeNotifier {
  UserDetails userDetails =
      UserDetails("", "", "", "", "", -1, -0.1, -1, -0.1, -1, -1, -1, -1);

  get getUserDetails {
    //print(userDetails._subscription_plan);
    return userDetails;
  }

  Future<void> fetchUserDetails() async {
    try {
      print("inside fetchUserDetails");
      final user = FirebaseAuth.instance.currentUser;
      final userData = await FirebaseFirestore.instance
          .collection("/user")
          .doc(user!.uid)
          .get();
      final url = await getImageUrl();
      userDetails = UserDetails(
        userData.get("username") as String,
        user.uid,
        userData.get("email"),
        url,
        userData.get("subscription_plan"),
        userData.get("total_meeting_credit"),
        userData.get("meeting_credit_consumed").toDouble(),
        userData.get("total_meeting_hours"),
        userData.get("meeting_hours_consumed").toDouble(),
        userData.get("no_offline_total"),
        userData.get("no_offline_consumed"),
        userData.get("no_upload_total"),
        userData.get("no_upload_consumed"),
      );
      print(userDetails);
    } catch (error) {
      //UserDetails("", "");
      print(error);
    }
    notifyListeners();
  }

  Future<String> getImageUrl() async {
    try {
      print("Image Url method");
      final user = FirebaseAuth.instance.currentUser;
      final ref = FirebaseStorage.instance
          .ref()
          .child(user!.uid)
          .child("profile")
          .child(user.uid + ".jpg");
      ;
      String url = (await ref.getDownloadURL()).toString();
      return url;
    } catch (error) {
      print("insie catch of get Image Url");
      return "https://images.unsplash.com/photo-1544502062-f82887f03d1c?q=80&w=3359&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
    }
  }

  Future<String> username() async {
    try {
      final user = await FirebaseAuth.instance.currentUser;
      final userData = await FirebaseFirestore.instance
          .collection("/user")
          .doc(user!.uid)
          .get();
      notifyListeners();
      return userData.get("username") as String;
    } catch (error) {
      print("Error => " + error.toString());
      return "No username";
    }
  }

  Future<String> findUserByEmail(String searchEmail) async {
    // final numberOfUserFound = await FirebaseFirestore.instance
    //     .collection("/user")
    //     .where("email", isEqualTo: searchEmail)
    //     .count()
    //     .get();
    // print(numberOfUserFound.count!);
    // if (numberOfUserFound.count! > 0) {
    //   return true;
    // } else {
    //   return false;
    // }
    final querySnapshot = await FirebaseFirestore.instance
        .collection("/user")
        .where("email", isEqualTo: searchEmail)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final userId = querySnapshot.docs.first.data()['userId'];
      return userId;
    } else {
      return ""; // or return a default value, or handle the case where no user is found
    }
  }

  Future<int> genrateCodeForMeetingCollaboration(String meetingId) async {
    int randomCode = Random().nextInt(9000) + 1000;
    print(randomCode);
    await FirebaseFirestore.instance.collection("/meetingCode").doc().set({
      "code": randomCode,
      "meetingId": meetingId,
    });
    return randomCode;
  }

  Future<void> addEmailInCollaboration(
      String userID, String email, bool isManual, String name) async {
    print(isManual);
    print("inside add email method");
    String method = "";
    if (isManual) {
      method = "By admin";
    } else {
      method = "Qr Scanned";
    }
    try {
      final userId = await findUserByEmail(email);
      await FirebaseFirestore.instance
          .collection("/user")
          .doc(userID)
          .collection("/collaboration")
          .doc()
          .set({
        "email": email,
        "method": method,
        "userId": userId,
        "name": name,
      });
      print("inside try");
    } catch (error) {
      print("Error : " + error.toString());
      return;
    }
  }

  Future<String> getUserNameById(String id) async {
    final document =
        await FirebaseFirestore.instance.collection("/user").doc(id).get();
    return document["username"];
  }

  Future<void> copyWavFile(String meetingName, String userId2) async {
    try {
      final userId = await FirebaseAuth.instance.currentUser!.uid;
      final FirebaseStorage _storage = FirebaseStorage.instance;
      // Source path
      Reference sourceRef = _storage.ref(
          '$userId/OfflineMeeting/${userId + meetingName}/$meetingName.wav');

      // Target path
      Reference targetRef = _storage.ref(
          '$userId2/OfflineMeeting/${userId2 + meetingName}/$meetingName.wav');

      // Download the file from the source path to a temporary location
      final Directory systemTempDir = Directory.systemTemp;
      final File tempFile = File('${systemTempDir.path}/temp_wav_file.wav');
      await sourceRef.writeToFile(tempFile);

      // Upload the temporary file to the target path
      await targetRef.putFile(tempFile);

      print("WAV file copied successfully!");
    } catch (e) {
      print("Failed to copy WAV file: $e");
    }
  }

  Future<void> getData(String meetingId) async {
    final user = FirebaseAuth.instance.currentUser;
    CollectionReference _collectionRef = FirebaseFirestore.instance
        .collection("/user")
        .doc(user!.uid)
        .collection("/collaboration");
    QuerySnapshot querySnapshot = await _collectionRef.get();
    List<Object?> allData =
        querySnapshot.docs.map((doc) => doc.data()).toList();
    // print(allData);
    // Map<String, dynamic> single = allData[1] as Map<String, dynamic>;
    // print(single["email"]);
    print(" length : ${allData.length}");
    for (int i = 0; i < allData.length; i++) {
      Map<String, dynamic> single = allData[i] as Map<String, dynamic>;
      if (!await isAlreadyAddedInMeetingCollaboration(
          single["email"], meetingId)) {
        print("inside qr i : $i");
        addEmailInMeetingCollaboration(
            meetingId, single["email"], false, single["name"]);
      }
    }
  }

  Future<bool> isAlreadyAddedInDashboardCollaboration(
      String searchEmail) async {
    final user = FirebaseAuth.instance.currentUser;
    final numberOfUserFound = await FirebaseFirestore.instance
        .collection("/user")
        .doc(user!.uid)
        .collection("/collaboration")
        .where("email", isEqualTo: searchEmail)
        .count()
        .get();
    if (numberOfUserFound.count! > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> isAlreadyAddedInMeetingCollaboration(
      String searchEmail, String meetingId) async {
    print("is already added in meeting collaboration");
    print("Search email : " + searchEmail);
    print(meetingId);
    final userId = FirebaseAuth.instance.currentUser!.uid;
    // final numberOfUserFound = await FirebaseFirestore.instance
    //     .collection("/user")
    //     .doc(userId)
    //     .collection("/meetingData")
    //     .doc("/OfflineMeeting")
    //     .collection(userId+meetingId)
    //     .doc("/MeetingCollaboration")
    //     .collection("/Participants")
    //     .where("email", isEqualTo: searchEmail)
    //     .count()
    //     .get();
    // print("result : ${numberOfUserFound.count!}");
    // if (numberOfUserFound.count! > 0) {
    //   return true;
    // } else {
    //   return false;
    // }
    try {
      // Access the Participants collection under the given path
      CollectionReference participantsCollection = FirebaseFirestore.instance
          .collection("/user")
          .doc(userId)
          .collection("/meetingData")
          .doc("/OfflineMeeting")
          .collection(meetingId)
          .doc("/MeetingCollaboration")
          .collection("/Participants");

      // Get all documents in the Participants collection
      QuerySnapshot snapshot = await participantsCollection.get();

      // Iterate through each document and check if the email exists
      for (var doc in snapshot.docs) {
        if (doc.exists && doc['email'] == searchEmail) {
          print("email found");
          return true; // Email found
        }
      }
    } catch (e) {
      print("Error checking email: $e");
    }

    return false;
  }

  Future<bool> deleteNameFromUploadMeetings(String nameToDelete) async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      // Reference to the user's document
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection("user").doc(userId);

      // Get the current document data
      DocumentSnapshot docSnapshot = await userDoc.get();

      if (docSnapshot.exists) {
        // Retrieve the latestMeetings array from the document
        List<dynamic> uploadMeetings = docSnapshot.get('uploadMeetings');

        if (uploadMeetings.contains(nameToDelete)) {
          // Remove the specified name from the array
          uploadMeetings.remove(nameToDelete);

          // Update the document with the modified array
          await userDoc.update({'uploadMeetings': uploadMeetings});
          print("Name removed successfully.");
          return true;
        } else {
          print("Name not found in the array.");
          return false;
        }
      } else {
        print("Document does not exist.");
        return false;
      }
    } catch (e) {
      print("Failed to delete name: $e");
      return false;
    }
  }

  Future<bool> deleteNameFromLatestMeetings(String nameToDelete) async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      // Reference to the user's document
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection("user").doc(userId);

      // Get the current document data
      DocumentSnapshot docSnapshot = await userDoc.get();

      if (docSnapshot.exists) {
        // Retrieve the latestMeetings array from the document
        List<dynamic> latestMeetings = docSnapshot.get('latestMeetings');

        if (latestMeetings.contains(nameToDelete)) {
          // Remove the specified name from the array
          latestMeetings.remove(nameToDelete);

          // Update the document with the modified array
          await userDoc.update({'latestMeetings': latestMeetings});
          print("Name removed successfully.");
          return true;
        } else {
          print("Name not found in the array.");
          return false;
        }
      } else {
        print("Document does not exist.");
        return false;
      }
    } catch (e) {
      print("Failed to delete name: $e");
      return false;
    }
  }

  Future<void> addMeetingNameInLatestMeeting(
      bool isOnline, String userId, String meetingName) async {
    // Get the current user from FirebaseAuth
    // User? user = FirebaseAuth.instance.currentUser;

    // Check if the user is not null
    if (meetingName.isNotEmpty) {
      // Define the document reference
      DocumentReference userDoc = FirebaseFirestore.instance
          .collection("user") // Make sure this collection name is correct
          .doc(userId);

      try {
        // Check if the document exists
        DocumentSnapshot docSnapshot = await userDoc.get();

        if (docSnapshot.exists) {
          if (isOnline) {
            // Document exists, update the array
            await userDoc.update({
              "latestMeetings": FieldValue.arrayUnion([meetingName])
            });
          } else {
            await userDoc.update({
              "uploadMeetings": FieldValue.arrayUnion([meetingName])
            });
          }
        } else {
          if (isOnline) {
            // Document does not exist, create it with an initial empty array
            await userDoc.set({
              "latestMeetings": [meetingName]
            });
          } else {
            await userDoc.set({
              "uploadMeetings": [meetingName]
            });
          }
        }

        print("Meeting added successfully");
      } catch (error) {
        print("Failed to add meeting: $error");
      }
    } else {
      print("User not logged in or meeting name is empty");
    }
  }

  /// Function to fetch the latest meetings array from Firestore
  Future<List<String>> getLatestMeetingsArray() async {
    // Get the current user from FirebaseAuth
    User? user = FirebaseAuth.instance.currentUser;

    // Check if the user is not null
    if (user != null) {
      try {
        // Define the document reference
        DocumentReference userDoc = FirebaseFirestore.instance
            .collection("user") // Make sure this collection name is correct
            .doc(user.uid);

        // Fetch the document snapshot
        DocumentSnapshot docSnapshot = await userDoc.get();

        if (docSnapshot.exists) {
          // Extract the array field from the document data
          List<dynamic>? meetings = docSnapshot.get("latestMeetings");

          // Convert the List<dynamic> to List<String> if necessary
          List<String> meetingList = meetings?.cast<String>() ?? [];

          // Return the latest 4 meetings if more than 4 meetings exist
          if (meetingList.length > 4) {
            return meetingList.sublist(meetingList.length - 4);
          } else {
            return meetingList;
          }
        } else {
          print("Document does not exist");
          return [];
        }
      } catch (error) {
        print("Failed to get latest meetings: $error");
        return [];
      }
    } else {
      print("User not logged in");
      return [];
    }
  }

  /// Function to fetch the latest meetings array from Firestore
  Future<List<String>> getAllMeetingsArray(bool isOffline) async {
    String meetingType = isOffline ? "latestMeetings" : "uploadMeetings";
    // Get the current user from FirebaseAuth
    User? user = FirebaseAuth.instance.currentUser;

    // Check if the user is not null
    if (user != null) {
      try {
        // Define the document reference
        DocumentReference userDoc = FirebaseFirestore.instance
            .collection("user") // Make sure this collection name is correct
            .doc(user.uid);

        // Fetch the document snapshot
        DocumentSnapshot docSnapshot = await userDoc.get();

        if (docSnapshot.exists) {
          // Extract the array field from the document data
          List<dynamic>? meetings = docSnapshot.get(meetingType);

          // Convert the List<dynamic> to List<String> if necessary
          List<String> meetingList = meetings?.cast<String>() ?? [];

          // Return the latest 4 meetings if more than 4 meetings exist

          return meetingList;
        } else {
          print("Document does not exist");
          return [];
        }
      } catch (error) {
        print("Failed to get latest meetings: $error");
        return [];
      }
    } else {
      print("User not logged in");
      return [];
    }
  }

  Future<List<LatestMeeting>> fetchLatestMeetings() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    List<LatestMeeting> latestMeetingList = [];
    List<String> meetingNamesArray = await getLatestMeetingsArray();
    for (int i = 0; i < meetingNamesArray.length; i++) {
      try {
        DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
            await FirebaseFirestore.instance
                .collection("/user")
                .doc(userId)
                .collection("/meetingData")
                .doc("OfflineMeeting")
                .collection(userId + meetingNamesArray[i])
                .doc("meetingDetails")
                .get();

        if (documentSnapshot.exists) {
          Map<String, dynamic>? data = documentSnapshot.data();
          if (data != null) {
            LatestMeeting latestMeeting = LatestMeeting(
              time: data['time'] as String,
              meetingName: data['meeting_name'] as String,
              duration: data['duration'] as String,
              type: data['type'] as String,
              hostName: data['host_name'] as String,
              hostId: data['host_id'] as String,
            );

            latestMeetingList.add(latestMeeting);
          }
        }
      } catch (e) {
        print('Error fetching data: $e');
      }
    }

    return latestMeetingList;
  }

  Future<List<LatestMeeting>> fetchMeetings(bool isOffline) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    List<LatestMeeting> latestMeetingList = [];
    List<String> meetingNamesArray = await getAllMeetingsArray(isOffline);
    // print("getall : ${meetingNamesArray.length}");
    for (int i = 0; i < meetingNamesArray.length; i++) {
      // print("inside loop : ${meetingNamesArray[i]}");
      try {
        DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
            await FirebaseFirestore.instance
                .collection("/user")
                .doc(userId)
                .collection("/meetingData")
                .doc(isOffline ? "OfflineMeeting" : "UploadMeeting")
                .collection(userId + meetingNamesArray[i])
                .doc("meetingDetails")
                .get();

        if (documentSnapshot.exists) {
          Map<String, dynamic>? data = documentSnapshot.data();
          if (data != null) {
            LatestMeeting latestMeeting = LatestMeeting(
              time: data['time'] as String,
              meetingName: data['meeting_name'] as String,
              duration: data['duration'] as String,
              type: data['type'] as String,
              hostName: data['host_name'] as String,
              hostId: data['host_id'] as String,
            );

            latestMeetingList.add(latestMeeting);
          }
        }
      } catch (e) {
        print('Error fetching data: $e');
      }
    }

    return latestMeetingList;
  }

  Future<bool> addMeetingNameAndDuration(
      String meetingName, String meetingType, String duration) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection("/user")
          .doc(user!.uid)
          .collection("/meetingData")
          .doc(meetingType)
          .collection(user.uid + meetingName)
          .doc("meetingDetails")
          .set({
        "meeting_name": meetingName,
        "duration": duration,
        "type": meetingType == "UploadMeeting" ? "Upload" : "Offline",
        "time":DateFormat.jm().format(DateTime.now()),
        "date": DateFormat("dd/MM/yyyy").format(DateTime.now()),
        "host_name": userDetails.getName(),
        "host_id": userDetails.getId(),
      });

      if (meetingType == "OfflineMeeting") {
        await addMeetingNameInLatestMeeting(true, user.uid, meetingName);
        updateUserUsagePlan(true, duration);
      } else {
        await addMeetingNameInLatestMeeting(false, user.uid, meetingName);
        updateUserUsagePlan(false, duration);
      }
      return true;
    } catch (error) {
      print("error : " + error.toString());
      return false;
    }
  }

  updateUserUsagePlan(bool isOffline, duration) async {
    double hours = convertTimeToHours(duration);
    userDetails.setMeeting_credit_consumed(
        userDetails.getMeeting_credit_consumed() + 1);
    userDetails.setMeeting_hours_consumed(
        userDetails.getMeeting_hours_consumed() + hours);

    if (isOffline) {
      userDetails
          .setNo_offline_consumed(userDetails.getNo_offline_consumed() + 1);
    } else {
      userDetails
          .setNo_upload_consumed(userDetails.getNo_upload_consumed() + 1);
    }
    try {
      final user = await FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection("/user")
          .doc(user!.uid)
          .update(
        {
          "meeting_credit_consumed": userDetails.getMeeting_credit_consumed(),
          "meeting_hours_consumed": userDetails.getMeeting_hours_consumed(),
          "no_offline_consumed": userDetails.getNo_offline_consumed(),
          "no_upload_consumed": userDetails.getNo_upload_consumed()
        },
      );

      /// Update the object
      userDetails.setSubscription_plan("Enterprise");
      userDetails.setTotal_meeting_hours(650);
      userDetails.setTotalMeeting_credit(45);
      userDetails.setNo_offline_total(30);
      userDetails.setNo_upload_total(15);
    } catch (error) {
      print("Error => $error");
    }
  }

  double convertTimeToHours(String time) {
    // Split the input string by colon
    List<String> parts = time.split(':');

    // Parse minutes and seconds
    int minutes = int.parse(parts[0]);
    int seconds = int.parse(parts[1]);

    // Convert total minutes and seconds to hours
    double hours = (minutes * 60 + seconds) / 3600;

    return hours;
  }

  Future<String> fetchMeetingName(String hostId, String meetingId) async {
    try {
      //final user = FirebaseAuth.instance.currentUser;
      final document = await FirebaseFirestore.instance
          .collection("/user")
          .doc(hostId)
          .collection("/meetingData")
          .doc("/OfflineMeeting")
          .collection(meetingId)
          .doc("meetingDetails")
          .get();
      print("meeting name : " + document["meeting_name"]);
      return document["meeting_name"];
    } catch (error) {
      print("Error : " + error.toString());
      return "no meeting found";
    }
  }

  Future<List<Map<String, dynamic>>> fetchMeetingCollaboration(
      String meetingName, String meetingType) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .collection('meetingData')
        .doc('${meetingType}Meeting')
        .collection(userId + meetingName)
        .doc('MeetingCollaboration')
        .collection('Participants')
        .get();

    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<void> updateAttendance(
      String userId, String attendance, String meetingName) async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;
      // Reference to the Participants collection
      CollectionReference participantsRef = FirebaseFirestore.instance
          .collection('user')
          .doc(currentUserId)
          .collection('meetingData')
          .doc('OfflineMeeting')
          .collection(currentUserId + meetingName)
          .doc('MeetingCollaboration')
          .collection('Participants');

      print(" count ${participantsRef.count()}");

      // Query to find the document with the specific userId
      QuerySnapshot querySnapshot =
          await participantsRef.where('userId', isEqualTo: userId).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document (assuming userId is unique)
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        String docId = documentSnapshot.id;

        // Update the attendance field
        await participantsRef.doc(docId).update({'attendance': attendance});

        print('Attendance updated successfully.');
      } else {
        print('No document found for userId: $userId');
      }
    } catch (e) {
      print('Error updating attendance: $e');
    }
  }

  Future<void> deleteParticipantFromMeetingCollaboration(
      String userId, String meetingId) async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;
      // Get a reference to the collection
      CollectionReference participantsCollection = FirebaseFirestore.instance
          .collection('user')
          .doc(currentUserId)
          .collection('meetingData')
          .doc('OfflineMeeting')
          .collection(meetingId)
          .doc('MeetingCollaboration')
          .collection('Participants');

      // Query the collection for the document with the matching userId
      QuerySnapshot querySnapshot =
          await participantsCollection.where('userId', isEqualTo: userId).get();

      // Loop through and delete each document that matches
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      print("Document(s) with userId $userId deleted successfully.");
    } catch (e) {
      print("Error deleting document(s): $e");
    }
  }

  Future<void> deleteParticipantFromCollaboration(String userId) async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;
      // Get a reference to the collection
      CollectionReference participantsCollection = FirebaseFirestore.instance
          .collection('user')
          .doc(currentUserId)
          .collection('collaboration');

      // Query the collection for the document with the matching userId
      QuerySnapshot querySnapshot =
          await participantsCollection.where('userId', isEqualTo: userId).get();

      // Loop through and delete each document that matches
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      print("Document(s) with userId $userId deleted successfully.");
    } catch (e) {
      print("Error deleting document(s): $e");
    }
  }

  void updateTopicDiscussed(meetingName, meetingType, topics) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .collection('meetingData')
        .doc('${meetingType}Meeting')
        .collection(userId + meetingName)
        .doc('meetingData')
        .collection('Task Assiging')
        .doc('topicDiscussed')
        .update({'topics': topics});
  }

  void updateTaskAssign(meetingName, meetingType, tasks) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .collection('meetingData')
        .doc('${meetingType}Meeting')
        .collection(userId + meetingName)
        .doc('meetingData')
        .collection('Task Assiging')
        .doc('taskAssign')
        .update({'tasks': tasks});
  }

  void updateTaskDone(meetingName, meetingType, tasks) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .collection('meetingData')
        .doc('${meetingType}Meeting')
        .collection(userId + meetingName)
        .doc('meetingData')
        .collection('Task Assiging')
        .doc('taskDone')
        .update({'tasks': tasks});
  }

  void updateSummary(String meetingName, String meetingType, String summary) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .collection('meetingData')
        .doc('${meetingType}Meeting')
        .collection(userId + meetingName)
        .doc('meetingData')
        .collection('Task Assiging')
        .doc('summary')
        .update({'summary': summary});
  }

  Future<bool> updateSpeakerName(String meetingName, String meetingType,
      String oldName, String newName) async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      // Reference to the collection
      CollectionReference dialoguesRef = FirebaseFirestore.instance
          .collection("/user")
          .doc(userId)
          .collection("/meetingData")
          .doc("${meetingType}Meeting")
          .collection("/${userId + meetingName}")
          .doc("/meetingData")
          .collection("/dialogues");

      // Query for documents where the 'Speaker' field matches the oldSpeaker value
      QuerySnapshot querySnapshot =
          await dialoguesRef.where('Speaker', isEqualTo: oldName).get();

      // Loop through the documents and update the 'Speaker' field
      for (var doc in querySnapshot.docs) {
        await dialoguesRef.doc(doc.id).update({'Speaker': newName});
      }

      print('Speaker name updated successfully.');
      return true;
    } catch (e) {
      print('Failed to update speaker name: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> fetchMeetingTasks(String meetingName,String meetingType) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    print(meetingType);
    String trimmedSummary = "";
    DocumentReference summaryDocRef = FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .collection('meetingData')
        .doc(meetingType)
        .collection(userId + meetingName)
        .doc('meetingData')
        .collection('Task Assiging')
        .doc('summary');

    DocumentReference taskAssignDocRef = FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .collection('meetingData')
        .doc(meetingType)
        .collection(userId + meetingName)
        .doc('meetingData')
        .collection('Task Assiging')
        .doc('taskAssign');

    // DocumentReference taskDoneDocRef = FirebaseFirestore.instance
    //     .collection('user')
    //     .doc(userId)
    //     .collection('meetingData')
    //     .doc(meetingType)
    //     .collection(userId + meetingName)
    //     .doc('meetingData')
    //     .collection('Task Assiging')
    //     .doc('taskDone');

    DocumentReference topicDiscussedDocRef = FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .collection('meetingData')
        .doc(meetingType)
        .collection(userId + meetingName)
        .doc('meetingData')
        .collection('Task Assiging')
        .doc('topicDiscussed');

    DocumentSnapshot summaryDoc = await summaryDocRef.get();
    DocumentSnapshot taskAssignDoc = await taskAssignDocRef.get();
    //DocumentSnapshot taskDoneDoc = await taskDoneDocRef.get();
    DocumentSnapshot topicDiscussedDoc = await topicDiscussedDocRef.get();
    return {
      'summary': summaryDoc.exists ? summaryDoc.data() : {},
      'taskAssign': taskAssignDoc.exists ? taskAssignDoc.data() : {},
      //'taskDone': taskDoneDoc.exists ? taskDoneDoc.data() : {},
      'topicDiscussed':
          topicDiscussedDoc.exists ? topicDiscussedDoc.data() : {},
    };
  }

  Future<List<Transcription>> getMeetingTranscription(
      String meetingName, String meetingType) async {
    List<Transcription> meetingTranscription = [];
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("/user")
          .doc(userId)
          .collection("/meetingData")
          .doc("${meetingType}Meeting")
          .collection("/${userId + meetingName}")
          .doc("/meetingData")
          .collection("/dialogues")
          .orderBy("Sequence")
          .get();

      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        Transcription transcription = Transcription(
          int.tryParse(data['Sequence'].toString()) ?? 0,
          // Assuming doc.id is unique enough for an ID
          double.tryParse(data['StartTime'].toString()) ?? 0.0,
          double.tryParse(data['EndPoint'].toString()) ?? 0.0,
          data['AudioFileName'] ?? '',
          data['Text'] ?? '',
          data['Speaker'].toString(),
        );
        meetingTranscription.add(transcription);
      }
      print(meetingTranscription.isEmpty.toString());
    } catch (error) {
      print(error.toString());
    }
    return meetingTranscription;
  }

  Future<bool> updateDialogueText(String meetingName, String meetingType,
      int sequence, String updatedText) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final userId = FirebaseAuth.instance.currentUser!.uid;
    // Navigate to the specific collection
    CollectionReference dialogues = firestore
        .collection("user")
        .doc(userId)
        .collection("meetingData")
        .doc("${meetingType}Meeting")
        .collection(userId + meetingName)
        .doc("meetingData")
        .collection("dialogues");

    try {
      // Perform a query to find the document with the matching 'Sequence'
      var querySnapshot =
          await dialogues.where('Sequence', isEqualTo: sequence).get();

      // Loop through the query results and update the 'Text' field
      for (var doc in querySnapshot.docs) {
        await doc.reference.update({'Text': updatedText});
      }
      print("Document(s) updated successfully.");
      return true;
    } catch (e) {
      print("Error updating document: $e");
      return false;
    }
  }

  Future<void> copyMeetingDialogues(
      String userId, String meetingName, String userId2) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      // Source path for Dialogues
      CollectionReference sourceDialoguesCollection = _firestore
          .collection('user')
          .doc(userId)
          .collection('meetingData')
          .doc('/OfflineMeeting')
          .collection(userId + meetingName)
          .doc('meetingData')
          .collection('dialogues');

      // Target path for Dialogues
      CollectionReference targetDialoguesCollection = _firestore
          .collection('user')
          .doc(userId2)
          .collection('meetingData')
          .doc('/OfflineMeeting')
          .collection(userId2 + meetingName)
          .doc('meetingData')
          .collection('dialogues');

      // Fetching all documents from the source Dialogues collection
      QuerySnapshot dialoguesSnapshot = await sourceDialoguesCollection.get();

      // Loop through each document and add it to the target Dialogues collection
      for (QueryDocumentSnapshot doc in dialoguesSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Create a new document in the target Dialogues collection with the same data
        await targetDialoguesCollection.doc(doc.id).set(data);
      }

      print("Dialogues data copied successfully!");
    } catch (e) {
      print("Failed to copy dialogues data: $e");
    }
  }

  Future<void> copyParticipantsData(
      String userId, String meetingName, String userId2) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      // Source path
      CollectionReference sourceCollection = _firestore
          .collection('user')
          .doc(userId)
          .collection('meetingData')
          .doc('/OfflineMeeting')
          .collection(userId + meetingName)
          .doc('MeetingCollaboration')
          .collection('Participants');

      // Target path
      CollectionReference targetCollection = _firestore
          .collection('user')
          .doc(userId2)
          .collection('meetingData')
          .doc('/OfflineMeeting')
          .collection(userId2 + meetingName)
          .doc('MeetingCollaboration')
          .collection('Participants');

      // Fetching all documents from the source collection
      QuerySnapshot sourceSnapshot = await sourceCollection.get();

      // Loop through each document and add it to the target collection
      for (QueryDocumentSnapshot doc in sourceSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Create a new document in the target collection with the same data
        await targetCollection.doc(doc.id).set(data);
      }

      print("Data copied successfully!");
    } catch (e) {
      print("Failed to copy data: $e");
    }
  }

  Future<void> copyTaskAssign(
      String userId, String meetingName, String userId2) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      // Source path for Task Assiging
      CollectionReference sourceTaskAssignCollection = _firestore
          .collection('user')
          .doc(userId)
          .collection('meetingData')
          .doc('/OfflineMeeting')
          .collection(userId + meetingName)
          .doc('meetingData')
          .collection('Task Assiging');

      // Target path for Task Assiging
      CollectionReference targetTaskAssignCollection = _firestore
          .collection('user')
          .doc(userId2)
          .collection('meetingData')
          .doc('/OfflineMeeting')
          .collection(userId2 + meetingName)
          .doc('meetingData')
          .collection('Task Assiging');

      // List of document IDs to copy
      List<String> documentsToCopy = [
        'summary',
        'taskAssign',
        'taskDone',
        'topicDiscussed'
      ];

      // Loop through each document and add it to the target Task Assiging collection
      for (String docId in documentsToCopy) {
        DocumentSnapshot sourceDocSnapshot =
            await sourceTaskAssignCollection.doc(docId).get();

        if (sourceDocSnapshot.exists) {
          Map<String, dynamic> data =
              sourceDocSnapshot.data() as Map<String, dynamic>;
          await targetTaskAssignCollection.doc(docId).set(data);
        }
      }

      print("Task Assign data copied successfully!");
    } catch (e) {
      print("Failed to copy Task Assign data: $e");
    }
  }

  Future<void> copyMeetingDetails(
      String userId, String meetingName, String userId2) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      // Source path for Meeting Details
      DocumentReference sourceMeetingDetailsDoc = _firestore
          .collection('user')
          .doc(userId)
          .collection('meetingData')
          .doc('/OfflineMeeting')
          .collection(userId + meetingName)
          .doc('meetingDetails');

      // Target path for Meeting Details
      DocumentReference targetMeetingDetailsDoc = _firestore
          .collection('user')
          .doc(userId2)
          .collection('meetingData')
          .doc('/OfflineMeeting')
          .collection(userId2 + meetingName)
          .doc('meetingDetails');

      // Fetch the document data from the source
      DocumentSnapshot sourceDocSnapshot = await sourceMeetingDetailsDoc.get();

      if (sourceDocSnapshot.exists) {
        Map<String, dynamic> data =
            sourceDocSnapshot.data() as Map<String, dynamic>;

        // Set the document data in the target path
        await targetMeetingDetailsDoc.set(data);
        print("Meeting details copied successfully!");
      } else {
        print("Source meeting details document does not exist.");
      }
    } catch (e) {
      print("Failed to copy meeting details: $e");
    }
  }

  Future<void> shareMeetingData(String meetingName, String userId2) async {
    final userId1 = FirebaseAuth.instance.currentUser!.uid;
    await copyParticipantsData(userId1, meetingName, userId2);
    await copyMeetingDialogues(userId1, meetingName, userId2);
    await copyTaskAssign(userId1, meetingName, userId2);
    await copyMeetingDetails(userId1, meetingName, userId2);
    await addMeetingNameInLatestMeeting(true, userId2, meetingName);
    await copyWavFile(meetingName, userId2);
  }

  Future<bool> isInMeetingCollaboration(
      String meetingId, String searchEmail) async {
    final user = FirebaseAuth.instance.currentUser;
    final numberOfUserFound = await FirebaseFirestore.instance
        .collection("/user")
        .doc(user!.uid)
        .collection("/meetingData")
        .doc("/OfflineMeeting")
        .collection(meetingId)
        .doc("/MeetingCollaboration")
        .collection("/Participants")
        .where("email", isEqualTo: searchEmail)
        .count()
        .get();
    if (numberOfUserFound.count! > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> genrateMOM(String meetingName, String ipAddress,String meetingType) async {
    final String _baseUrl = 'http://${ipAddress}:4500';
    final url = Uri.parse('$_baseUrl/document');
    final userId = await FirebaseAuth.instance.currentUser!.uid;

    final response = await https.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'meetingName': meetingName,
        'userId': userId,
        'meetingType':"${meetingType}Meeting",
      }),
    );

    if (response.statusCode == 200) {
      print('Success: ${response.body}');
      return true;
    } else {
      print('Error: ${response.statusCode}');
      return false;
    }
  }

  Future<String> getMeetingIdThroughCode(int code) async {
    try {
      // Reference to the "meetingCode" collection
      CollectionReference meetingCodeCollection =
          FirebaseFirestore.instance.collection('meetingCode');

      // Query to find the document with the specified "code"
      QuerySnapshot querySnapshot =
          await meetingCodeCollection.where('code', isEqualTo: code).get();

      // Check if any document is found
      if (querySnapshot.docs.isNotEmpty) {
        // Assuming there's only one document with the matching code, return the "meetingId"
        return querySnapshot.docs.first.get('meetingId');
      } else {
        // No document found with the specified "code"
        return "";
      }
    } catch (e) {
      // Handle errors (e.g., network issues, Firestore permission errors)
      print("Error searching for meeting code: $e");
      return "";
    }
  }

  Future<String> joinMeetingByCode(int code) async {
    String meetingId = await getMeetingIdThroughCode(code);
    if (meetingId.isEmpty) {
      return "Invalid code";
    } else {
      bool result = await markAttendance(
          userDetails.getId(), meetingId, userDetails.getEmail());
      if (result) {
        return "Added Successfully in meeting collaboration";
      } else {
        return "Unable to add you in meeting collaboration";
      }
    }
  }

  Future<bool> markAttendance(
      String hostId, String meetingId, String searchEmail) async {
    try {
      //final user = FirebaseAuth.instance.currentUser;
      final document = await FirebaseFirestore.instance
          .collection("/user")
          .doc(hostId)
          .collection("/meetingData")
          .doc("/OfflineMeeting")
          .collection(meetingId)
          .doc("/MeetingCollaboration")
          .collection("/Participants")
          .where("email", isEqualTo: searchEmail)
          .get();

      document.docs.forEach((doc) async {
        if (doc.data()['email'] == searchEmail) {
          await FirebaseFirestore.instance
              .collection("/user")
              .doc(hostId)
              .collection("/meetingData")
              .doc("/OfflineMeeting")
              .collection(meetingId)
              .doc("/MeetingCollaboration")
              .collection("/Participants")
              .doc(doc.id)
              .update({'attendance': 'Present'});
        }
      });
      return true;
    } catch (error) {
      return false;
    }
  }

  // Future<String> getUserIdByEmail(String email) async {
  //   try {
  //     // Reference to the Firestore collection
  //     final firestore = FirebaseFirestore.instance;
  //     final collectionRef = firestore.collection("userEmailAId");
  //
  //     // Query Firestore for the document with the given email
  //     QuerySnapshot querySnapshot =
  //         await collectionRef.where('email', isEqualTo: email).get();
  //
  //     // Check if the document exists and return the userId if found
  //     if (querySnapshot.docs.isNotEmpty) {
  //       // Assuming there's only one document with the given email
  //       String userId = querySnapshot.docs.first['userId'];
  //       return userId;
  //     } else {
  //       // No document found with the given email
  //       return "";
  //     }
  //   } catch (e) {
  //     print('Error retrieving userId: $e');
  //     return "";
  //   }
  // }

  Future<void> addEmailInMeetingCollaboration(
      String meetingId, String email, bool isPresent, String name) async {
    if (!await isAlreadyAddedInMeetingCollaboration(
      email,
      meetingId,
    )) {
      //print(isManual);
      print("inside add email method");
      String method = "";
      if (isPresent) {
        method = "Present";
      } else {
        method = "Absent";
      }
      try {
        final userId = await findUserByEmail(email);
        print(userId);
        final user = FirebaseAuth.instance.currentUser;
        await FirebaseFirestore.instance
            .collection("/user")
            .doc(user!.uid)
            .collection("/meetingData")
            .doc("/OfflineMeeting")
            .collection(meetingId)
            .doc("/MeetingCollaboration")
            .collection("/Participants")
            .doc()
            .set({
          "email": email,
          "attendance": method,
          "userId": userId,
          "name": name,
        });
        print("inside try");
      } catch (error) {
        print("Error : " + error.toString());
        return;
      }
    }
  }

  Future<bool> uploadAudioDemoAudio(
      String _audioFilePath, String ipAddress, String username) async {
    //  final url = Uri.parse('http://${ipAddress}:4500/upload-audio');
    //
    // try {
    //   final request = https.MultipartRequest('POST', url);
    //   request.files.add(await https.MultipartFile.fromPath(
    //     'audio',
    //     _audioFilePath,
    //     contentType: MediaType('audio',
    //         'mp3'), // Adjust content type according to your audio file type
    //   ));
    //
    //   // Adding other fields
    //   request.fields['username'] = username;
    //
    //   final streamedResponse = await request.send();
    //   final response = await https.Response.fromStream(streamedResponse);
    //
    //   if (response.statusCode == 200) {
    //     // Successfully uploaded
    //     print('Demo Audio uploaded successfully');
    //     return true;
    //   } else {
    //     // Handle errors
    //     print('Demo Failed to upload audio: ${response.body}');
    //     return false;
    //   }
    // } catch (error) {
    //   print('Error uploading Demo  audio: $error');
    //   return false;
    // }
    var uri = Uri.parse('http://${ipAddress}:4500/upload-audio');
    var request = https.MultipartRequest('POST', uri)
      ..fields['username'] = username
      ..files
          .add(await https.MultipartFile.fromPath('audioFile', _audioFilePath));

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Uploaded!');
      return true;
    } else {
      print('Failed with status code: ${response.statusCode}');
      return false;
    }
  }

  Future<bool> uploadAudio(String _audioFilePath, String ipAddress,
      String meetingName, String meetingType) async {
    final url = Uri.parse('http://${ipAddress}:4500/upload');

    try {
      final request = https.MultipartRequest('POST', url);
      request.files.add(await https.MultipartFile.fromPath(
        'audio',
        _audioFilePath,
        contentType: MediaType('audio',
            'mp3'), // Adjust content type according to your audio file type
      ));

      // Adding other fields
      request.fields['meetingName'] = meetingName;
      request.fields['typeOfMeeting'] = meetingType;
      request.fields['userId'] = userDetails.getId();

      final streamedResponse = await request.send();
      final response = await https.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Successfully uploaded
        print('Audio uploaded successfully');
        return true;
      } else {
        // Handle errors
        print('Failed to upload audio: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error uploading audio: $error');
      return false;
    }
  }

  dashboardCollaborationSteam() {
    final user = FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance
        .collection("/user")
        .doc(user!.uid)
        .collection("/collaboration")
        .snapshots();
  }

  Future<String> userId() async {
    final user = FirebaseAuth.instance.currentUser;

    notifyListeners();
    return user!.uid;
  }

  Future<bool> uploadImage(var imgFile) async {
    String userid = await userId();
    final ref = FirebaseStorage.instance
        .ref()
        .child(userid)
        .child("profile")
        .child(userid + ".jpg");
    await ref.putFile(imgFile!).then((status) {
      if (status.state == TaskState.success) {
        return true;
      } else {
        return false;
      }
    });
    //image_url = await ref.getDownloadURL();
    notifyListeners();
    return true;
  }

  Future<void> changeUsername(String newName) async {
    try {
      final user = await FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection("/user")
          .doc(user!.uid)
          .update({"username": newName});

      /// Update the object
      userDetails.setName(newName);
    } catch (error) {
      print("Error => $error");
    }
  }

  Future<void> upgradeSubscriptionPlan() async {
    try {
      final user = await FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection("/user")
          .doc(user!.uid)
          .update(
        {
          "subscription_plan": "Enterprise",
          "total_meeting_hours": 650,
          "total_meeting_credit": 45,
          "no_offline_total": 30,
          "no_upload_total": 15
        },
      );

      /// Update the object
      userDetails.setSubscription_plan("Enterprise");
      userDetails.setTotal_meeting_hours(650);
      userDetails.setTotalMeeting_credit(45);
      userDetails.setNo_offline_total(30);
      userDetails.setNo_upload_total(15);
    } catch (error) {
      print("Error => $error");
    }
  }

  Future<bool> deleteUserAccount() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      User? user = _auth.currentUser;
      if (user != null) {
        await user.delete();

        await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .delete();

        print('User account deleted successfully');
        // Optionally, navigate to a login or home screen after deletion
        return true;
      } else {
        print('No user is signed in');
        return false;
      }
    } catch (e) {
      print('Failed to delete user: $e');
      return false;
    }
  }
}
