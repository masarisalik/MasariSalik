import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:masari_salik_app/controller/nearestHospital_controller.dart';
import 'package:masari_salik_app/style/fonts.dart';
import 'package:masari_salik_app/view/user/chat_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../routes/app_pages.dart';
import '../../style/app_color.dart';
import '../../widgets/Drawer.dart';

class NearestHospitalScreen extends GetView<NearestHospitalController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Masari Salik",
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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Obx(
                    () => controller.hosName.value == ''
                        ? CircularProgressIndicator(
                            color: AppColor.primary,
                          )
                        : Text(
                            controller.hosName.value,
                            style: robotoExtraHuge,
                          ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                        _callEmergencyNumber(controller.hosPhone.value );
                        },
                        label: Text(
                          "Call",
                          style: robotoExtraHuge,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor
                              .primarySoft, // Change this to your desired button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Adjust the radius as needed
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                        ),
                        icon: Icon(
                          Icons.call,
                          size: 32,
                          color: AppColor.primary,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                recipientUserId: controller.hosId.value,
                                recipientEmail: controller.hosEmail.value,
                                recipientToken:
                                    controller.hosDeviceToken.value ?? "",
                              ),
                            ),
                          );
                        },
                        label: Text(
                          "Chat with",
                          style: robotoExtraHuge,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor
                              .primarySoft, // Change this to your desired button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Adjust the radius as needed
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                        ),
                        icon: Icon(
                          Icons.chat,
                          size: 32,
                          color: AppColor.primary,
                        ),
                      ),
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


    void _callEmergencyNumber(String phone ) async {
    String number = 'tel:$phone';
    if (await canLaunch(number)) {
      await launch(number);
    } else {
      throw 'Could not launch $number';
    }
  }
}
