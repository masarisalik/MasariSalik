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
import 'complains.dart';

class HomeScreen extends GetView<LoginController> {
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
              InkWell(
                  onTap: () {
                    //    Get.to(() => ComplaintList());
                    Get.toNamed(Routes.PATIENTINFOSCREEN);
                  },
                  child: Image.asset(Images.mainButton)),
              Text(
                "Tap on Screen to\n Emergency Alert",
                style: robotoExtraHuge,
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
