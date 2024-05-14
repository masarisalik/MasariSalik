import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masari_salik_app/style/app_color.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/login_controller.dart';
import '../../routes/app_pages.dart';
import '../../style/fonts.dart';
import '../../style/images.dart';
import '../../widgets/Drawer.dart';
import '../../widgets/custom_input.dart';

class PatientInformationScreen extends GetView<LoginController> {
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
            onPressed: () {Get.toNamed(Routes.EDITPROFILESCREEN);},
          )
        ],
        iconTheme: IconThemeData(color: AppColor.primary),
      ),
      drawer: const MyDrawer(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Patient Information",
                style: robotoExtraHuge,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(Routes.CHOOSESTATUS);
                    },
                    child: Text(
                      "My Information",
                      style: robotoExtraHuge,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor
                          .primarySoft, // Change this to your desired button color

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Adjust the radius as needed
                      ),

                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(Routes.ANOTHERPATIENTINFOSCREEN);
                    },
                    child: FittedBox(
                      child: Text(
                        "Another Patient information",
                        style: robotoExtraHuge,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primarySoft,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
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
