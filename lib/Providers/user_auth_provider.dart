import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserAuthProvider with ChangeNotifier {
  Future<void> login(String email, String password) async {
    final _auth = FirebaseAuth.instance;
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> createNewUser(
      String email, String password, String _username) async {
    print("inside create new user");
    print("username : $_username");

    try {
      final _auth = FirebaseAuth.instance;
      final authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print("user id getted : ${authResult.user!.uid}");
      try {
        FirebaseFirestore.instance
            .collection("user")
             .doc(authResult.user!.uid)
            // .doc("test")
            .set({
          "userId": authResult.user!.uid,
          "username": _username,
          "email": email,
          "subscription_plan": "Standard",
          "total_meeting_credit": 20,
          "meeting_credit_consumed": 0.0,
          "total_meeting_hours": 300,
          "meeting_hours_consumed": 0.0,
          "no_offline_total": 15,
          "no_offline_consumed": 0,
          "no_upload_total": 5,
          "no_upload_consumed": 0,
          // "latestMeetings":[],
        });
      } catch (error) {
        print("Error : " + error.toString());
      }

      // DocumentReference userDoc = FirebaseFirestore.instance
      //     .collection("user") // Make sure this collection name is correct
      //     .doc(authResult.user!.uid);
      //
      // await userDoc.set({"latestMeetings": []});
      // await userDoc.set({"uploadMeetings": []});

      // FirebaseFirestore.instance.collection("user").doc("profile").set({
      //   "profileImage":
      //       "https://images.unsplash.com/photo-1544502062-f82887f03d1c?q=80&w=3359&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      // });
    } catch (error) {
      return;
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  Future<bool> getUserByEmail(String email) async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('/user');
    QuerySnapshot querySnapshot =
        await userCollection.where('email', isEqualTo: email).get();
    if (querySnapshot.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> sendResetPassword(String _userEmail) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _userEmail);
      return ("Reset Password request sended to your registered email.");
    } catch (error) {
      return (error.toString());
    }
  }

  Future<String> changePassword(
      String newPassword, String oldPassword, String email) async {
    String result = "";
    try {
      print("inside try");
      print("Email : " + email);
      print("old password : " + oldPassword);
      print("new password : " + newPassword);
      final user = FirebaseAuth.instance;
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: oldPassword);
      await user.currentUser!
          .reauthenticateWithCredential(credential)
          .whenComplete(() => user.currentUser!.updatePassword(newPassword))
          .then((value) => result = "successful")
          .onError((error, stackTrace) => result = error.toString());
    } catch (error) {
      print("inside catch");
      result = error.toString();
    }
    return result;

    // try {
    //   print("inside change method");

    //   print("email $email");
    //   UserCredential userCredential =
    //       await FirebaseAuth.instance.signInWithEmailAndPassword(
    //     email: email,
    //     password: oldPassword,
    //   );
    //   await userCredential.user!.updatePassword(newPassword);
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'weak-password') {
    //     print('The password provided is too weak.');
    //   } else if (e.code == 'requires-recent-login') {
    //     print('The user must reauthenticate before updating their password.');
    //   }
    // }
    // return "";
  }
}
