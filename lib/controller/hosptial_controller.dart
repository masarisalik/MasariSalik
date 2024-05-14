import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/app_pages.dart';
import '../widgets/custom_toast.dart';

class HospitalController extends GetxController {
  @override
  void onInit() {
    getWhoChatWithHospital();
    super.onInit();
  }

  // Future<List<String>> getWhoChatWithHospital() async {
  //   try {
  //     QuerySnapshot messagesQuery = await FirebaseFirestore.instance
  //         .collection('whochatted')
  //         .where('recieverId',
  //             isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //         .get();

  //     List<String> senders = [];
  //     // Iterate over each message to extract sender IDs
  //     messagesQuery.docs.forEach((doc) {
  //       String senderId = doc[
  //           'senderId']; // Assuming 'senderId' is the field containing sender's ID
  //       senders.add(senderId);
  //     });
  //     print('senders: $senders');
  //     return senders;
  //   } catch (e) {
  //     // Handle any errors
  //     print('Error: $e');
  //     return [];
  //   }
  // }
  Future<List<Map<String, dynamic>>> getWhoChatWithHospital() async {
    try {
      QuerySnapshot messagesQuery = await FirebaseFirestore.instance
          .collection('whochatted')
          .where('recieverId',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      List<String> senders = [];
      messagesQuery.docs.forEach((doc) {
        String senderId = doc[
            'senderId']; // Assuming 'senderId' is the field containing sender's ID
        senders.add(senderId);
      });

      // Check if senders list is empty
      if (senders.isEmpty) {
        return []; // or handle according to your application logic
      }

      // Fetch data from 'users' collection using sender IDs
      QuerySnapshot usersQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('userId', whereIn: senders)
          .get();

      List<Map<String, dynamic>> userData = [];
      usersQuery.docs.forEach((doc) {
        Map<dynamic, dynamic>? docData = doc.data() as Map<dynamic,
            dynamic>?; // Cast doc.data() to Map<dynamic, dynamic> or null
        if (docData != null) {
          Map<String, dynamic> userDataMap = Map<String, dynamic>.from(docData);
          userData.add(userDataMap);
        }
      });
      print(userData);
      return userData;
    } catch (e) {
      // Handle any errors
      print('Error: $e');
      return [];
    }





  }


   Future<List<Map<String, dynamic>>> getRequests() async {
  try {
    QuerySnapshot operations = await FirebaseFirestore.instance
        .collection('users')
        .where('hospitalId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    List<Map<String, dynamic>> requests = [];
    for (var doc in operations.docs) {
      requests.add(doc.data() as Map<String, dynamic>);
    }
    return requests;
  } catch (e) {
    print('Failed to fetch data: $e');
    throw e; // Re-throw the error to be handled by the caller
  }
}

}