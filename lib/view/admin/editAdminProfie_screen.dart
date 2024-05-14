import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masari_salik_app/style/app_color.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../controller/editProfile_controller.dart';
import '../../style/fonts.dart';
import '../../widgets/custom_input.dart';

class EditAdminProfileScreen extends GetView<EditProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.primary),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text("Edit your Account", style: robotoExtraHuge),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.0),
                  ),
                  contentPadding: EdgeInsets.all(12.0),
                  subtitle: SingleChildScrollView(
                    child: Column(
                      children: [
                        CustomInput(
                          controller: controller.nameC,
                          label: "Name",
                          hint: controller.nameC.text,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IntlPhoneField(
                            controller: controller.phoneC,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            initialCountryCode: 'SA', // Initial country code
                            onChanged: (phone) {
                              // Handle phone number changes
                            },
                            initialValue: controller.phoneC.text,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                controller.editProfile();
                              },
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
                              child: Text(
                                "Update Profile",
                                style: robotoExtraHuge,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
