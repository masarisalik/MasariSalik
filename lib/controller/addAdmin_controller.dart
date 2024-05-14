import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../widgets/custom_toast.dart';

class AddAdminController extends GetxController {
  TextEditingController phoneC = TextEditingController();
  TextEditingController fNameC = TextEditingController();
  TextEditingController lNameC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController passC = TextEditingController();
  TextEditingController confirmPassC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  var isLoading = false.obs;

  Future<void> createAdmin() async {
    isLoading.value = true;
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailC.text.trim(),
        password: passC.text.trim(),
      );

      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;

        DocumentReference user =
            FirebaseFirestore.instance.collection("users").doc(uid);
        await user.set({
          "name": '${fNameC.text} ${lNameC.text}',
          "phone": phoneC.text,
          "email": emailC.text,
          "userId": uid,
          "createdAt": DateTime.now().toIso8601String(),
          "role": "admin"
        });

        Get.back();

        CustomToast.successToast('Admin Account Created Successfully');
        isLoading.value = false;
      }
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        CustomToast.errorToast(
            'Your password is too weak. It should be at least 6 characters');
      } else if (e.code == 'email-already-in-use') {
        CustomToast.errorToast('This account is already registered');
      } else if (e.code == 'wrong-password') {
        CustomToast.errorToast('Password is wrong');
      } else {
        CustomToast.errorToast('Error: ${e.code}');
        print("The problem is ${e.code}");
      }
    } catch (e) {
      CustomToast.errorToast('Error: $e');
      print('The error is $e');
    }
  }
}
