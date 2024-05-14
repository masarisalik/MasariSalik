import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masari_salik_app/routes/app_pages.dart';
import 'package:masari_salik_app/style/app_color.dart';
import 'package:masari_salik_app/style/fonts.dart';
import 'package:masari_salik_app/style/images.dart';

class StartEmergencyScreen extends StatelessWidget {
  const StartEmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primarySoft,
      appBar: AppBar(
        backgroundColor: AppColor.primarySoft,
        iconTheme: IconThemeData(color: AppColor.primary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 250, width: 250, child: Image.asset(Images.SOS)),
              Text(
                "Emergency Calling...",
                style: robotodarkHuge,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(Images.alerting),
              ),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () async {updateAlertValue() ;},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 80,
                      vertical: 10,
                    ),
                  ),
                  child: Text(
                    "DONE!",
                    style: robotoMediumLightBold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



     void updateAlertValue() {
  DatabaseReference dbRef = FirebaseDatabase.instance.reference();

  // Path to the node where "Alert" field is located
  String pathToAlertField = 'Alert';

  // Update the value of the "Alert" field to 1
  dbRef.child(pathToAlertField).set("0").then((_) {
    print('Alert value updated successfully.');
    Get.offAndToNamed(Routes.HOMESCREEN);

  }).catchError((error) {
    print('Failed to update alert value: $error');
  });
}
}
