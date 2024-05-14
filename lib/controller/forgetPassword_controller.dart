import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/custom_toast.dart';

class ForgetPasswordController extends GetxController {
  TextEditingController emailC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> resetPassword() async {
    if (emailC.text.isNotEmpty) {
      try {
        auth.sendPasswordResetEmail(email: emailC.text);
        CustomToast.successToast("Please Check your Email to reset password");
      } catch (e) {
        CustomToast.errorToast("something went wrong $e");
      }
    } else {
      CustomToast.errorToast("Please fill the email field ");
    }
  }
}
