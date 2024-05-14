import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masari_salik_app/controller/hosptial_controller.dart';
import 'package:masari_salik_app/routes/app_pages.dart';
import 'package:masari_salik_app/style/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../style/fonts.dart';
import '../../widgets/Drawer.dart';


class HospitalHomeScreen extends GetView<HospitalController> {
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
              controller.getWhoChatWithHospital();
            },
          )
        ],
        iconTheme: IconThemeData(color: AppColor.primary),
      ),
      drawer: const MyDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () async {
               Get.toNamed(Routes.REQUESTSSCREEN);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primarySoft,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 30, vertical: 10),
                ),
                child:Text(
                    "Requests",
                    style: robotoExtraHuge,
                )),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () async {
             Get.toNamed(Routes.CHATLISTSCREEN);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primarySoft,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 30, vertical: 10),
                ),
                child:  Text(
                    "Chats",
                    style: robotoExtraHuge,
                  )),
          ),
        ),


      ],)
    );
  }
}
