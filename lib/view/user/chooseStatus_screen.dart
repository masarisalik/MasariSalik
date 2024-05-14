import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masari_salik_app/controller/chooseStatusController.dart';
import 'package:masari_salik_app/style/app_color.dart';
import 'package:masari_salik_app/view/user/editProfie_screen.dart';
import 'package:masari_salik_app/view/user/map_screen.dart';
import 'package:masari_salik_app/view/user/nearestHospital_screen.dart';
import 'package:masari_salik_app/view/user/google_maps.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../style/fonts.dart';
import '../../widgets/Drawer.dart';

class ChooseStatusScreen extends GetView<ChooseStatusController> {
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
             onPressed: () {Get.to(EditProfileScreen());},
          )
        ],
        iconTheme: IconThemeData(color: AppColor.primary),
      ),
      drawer: const MyDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                "Which of the following best describes your symptoms?",
                style: robotodarkHuge,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: ListView.builder(
                    itemCount: controller.complaints.length,
                    itemBuilder: (context, index) {
                      final complaint = controller.complaints[index];
                      return InkWell(
                        onTap: () async {
                          // Get.to(FindHospitalScreen(
                          //   complaint: complaint.complain, complaintType: complaint.complainType,
                          // ));
                          Get.to(HospitalMapScreen( complaint: complaint.complain, complaintType: complaint.complainType));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColor.primarySoft,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                complaint
                                    .complain, // Display the complaint description here
                                style: robotoMediumBold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(NearestHospitalScreen());
                    },
                    child: Text(
                      "None of the above",
                      style: robotoHuge,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // Call 911 when tapped
                  _callEmergencyNumber();
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: AppColor.primarySoft,
                          ),
                          child: Icon(
                            Icons.call,
                            color: AppColor.primary,
                            size: 32,
                          )),
                      Text(
                        " Emergency numbers",
                        style: robotodarkHuge,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _callEmergencyNumber() async {
    const number = 'tel:911';
    if (await canLaunch(number)) {
      await launch(number);
    } else {
      throw 'Could not launch $number';
    }
  }
}
