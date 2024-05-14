import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masari_salik_app/style/app_color.dart';

import '../../controller/forgetPassword_controller.dart';
import '../../style/fonts.dart';
import '../../widgets/custom_input.dart';

class ForgetPasswordScreen extends GetView<ForgetPasswordController> {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Forget your Password",
          style: robotoMediumBold,
        ),
        backgroundColor: AppColor.primarySoft,
        iconTheme: const IconThemeData(
          color: AppColor.primary,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Text("Enter your Email to reset your password"),
            CustomInput(
                controller: controller.emailC, label: "Email", hint: ""),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                child: ElevatedButton(
                  onPressed: () async {
                    controller.resetPassword();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primarySoft,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the radius as needed
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                  ),
                  child: Text("Reset", style: robotodarkHuge),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
