import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';
import '../style/app_color.dart';
import '../style/fonts.dart';

Future<bool> alertExitApp() {
  Get.defaultDialog(
    title: "Logout!",
    titleStyle: const TextStyle(
      color: AppColor.primaryColor,
      fontWeight: FontWeight.bold,
    ),
    middleText: "Are you sure you want to log out?",
    actions: [
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppColor.redColor),
        ),
        onPressed: () {
          Get.offAllNamed(Routes.SPLASHSCREEN);
        },
        child: Text("Yes", style: robotoMediumWhite),
      ),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppColor.primary),
        ),
        onPressed: () {
          Get.back();
        },
        child: Text("No", style: robotoMediumWhite),
      ),
    ],
  );
  return Future.value(true);
}
