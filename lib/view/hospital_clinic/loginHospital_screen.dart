import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masari_salik_app/style/app_color.dart';

import '../../controller/login_controller.dart';
import '../../routes/app_pages.dart';
import '../../style/fonts.dart';
import '../../style/images.dart';
import '../../widgets/custom_input.dart';

class LoginHospitalScreen extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                Images.Logo,
                scale: 2,
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
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Welcome", style: robotoExtraHuge),
                        Text("Login to Masari Salik", style: robotoHuge),
                      ],
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomInput(
                          controller: controller.emailC,
                          label: "Email",
                          hint: "",
                          //keyboardType: TextInputType.number,
                        ),
                        CustomInput(
                            controller: controller.passC,
                            label: 'Password',
                            hint: 'Type your Password',
                            obscureText: true),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                await controller.login();
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
                                "Sign in",
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
            ],
          ),
        ),
      ),
    );
  }
}
