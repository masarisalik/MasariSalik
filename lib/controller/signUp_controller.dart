import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../widgets/custom_toast.dart';

class SignUpController extends GetxController {
  TextEditingController phoneC = TextEditingController();
  TextEditingController fNameC = TextEditingController();
  TextEditingController lNameC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController passC = TextEditingController();
  TextEditingController confirmPassC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController weightC = TextEditingController();
  TextEditingController heightC = TextEditingController();
  var gender = ['female', 'male'];
  var selectedgender = RxString('female');

  var isLoading = false.obs;

  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

  Rx<DateTime> selectedDate = DateTime.now().obs;

  void updateSelectedDate(DateTime newDate) {
    selectedDate.value = newDate;
  }

  Future<void> createUser() async {
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
          "height": heightC.text,
          "weight": weightC.text,
          "birthdate": selectedDate.value.toIso8601String(),
          "gender": selectedgender.value,
          "role": "user"
        });

        Get.back();

        CustomToast.successToast('Your Account Created Successfully');
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
