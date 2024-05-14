import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:masari_salik_app/style/fonts.dart';

import '../../controller/hosptial_controller.dart';
import '../../routes/app_pages.dart';
import '../../style/app_color.dart';
import '../../widgets/Drawer.dart';

class RequestsScreen extends GetView<HospitalController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Welcome to Masari Salik",
            style: robotoMediumBold,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.person_2),
              onPressed: () {
                Get.toNamed(Routes.EDITPROFILESCREEN);
              },
            )
          ],
          iconTheme: IconThemeData(color: AppColor.primary),
        ),
        drawer: const MyDrawer(),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('operations')
                .where('hospitalId',
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text('No operations found'),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  var operation = snapshot.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        // Navigate to chat screen or perform any action
                      },
                      child: Card(
                        elevation: 4.0,
                        color: AppColor.primarySoft,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: InkWell(
                          onTap: () {},
                          child: ListTile(
                            title: Text(
                              operation['name'],
                              style: robotoMediumBold,
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "phone: ${operation['phone']}",
                                  style: robotoRegular,
                                ),
                                Text(
                                  "BirthDate: ${operation['birthdate']}",
                                  style: robotoRegular,
                                ),
                                Text(
                                  "Complaint: ${operation['complaint']}",
                                  style: robotoRegular,
                                ),
                                Text(
                                  "Gender: ${operation['gender']}",
                                  style: robotoRegular,
                                ),
                                Text(
                                  "Height: ${operation['height']}",
                                  style: robotoRegular,
                                ),
                                Text(
                                  "Weight: ${operation['weight']}",
                                  style: robotoRegular,
                                ),
                                Text(
                                  "Complaint: ${operation['complaint']}",
                                  style: robotoRegular,
                                ),
                                Text(
                                  "Time: ${operation['date']}",
                                  style: robotoMediumBold,
                                ),
                              ],
                            ),
                            leading: Icon(
                              Icons.warning_outlined,
                              color: AppColor.primary,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }));
  }
}
