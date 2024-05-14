import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:masari_salik_app/routes/app_pages.dart';

import '../widgets/custom_toast.dart';

class AnotherPatientInfoController extends GetxController {
  TextEditingController phoneC = TextEditingController();
  TextEditingController fNameC = TextEditingController();
  TextEditingController lNameC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController passC = TextEditingController();
  TextEditingController confirmPassC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController weightC = TextEditingController();
  TextEditingController heightC = TextEditingController();
  var gender = ['Female', 'Male'];
  var selectedgender = RxString('Female');

  var isLoading = false.obs;

  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

  Rx<DateTime> selectedDate = DateTime.now().obs;

  void updateSelectedDate(DateTime newDate) {
    selectedDate.value = newDate;
  }

  Future<void> addAnotherPatient() async {
    isLoading.value = true;
    try {
      // DocumentReference user =
      //     FirebaseFirestore.instance.collection("patients").doc();
      // await user.set({
      //   "name": nameC.text,
      //   "phone": phoneC.text,
      //   "createdAt": DateTime.now().toIso8601String(),
      //   "height": heightC.text,
      //   "weight": weightC.text,
      //   "birthdate": selectedDate.value.toIso8601String(),
      //   "gender": selectedgender.value,
      // });


Get.toNamed(
  Routes.CHOOSESTATUSFORPATIENT,
  arguments: {
    'name': nameC.text,
    'phone': phoneC.text,
    'birthDate':selectedDate.value.toIso8601String(),
    "gender": selectedgender.value,
    "height": heightC.text,
    "weight": weightC.text,
  },
);

      CustomToast.successToast('Added Successfully');
    } catch (error) {
      // Handle the error appropriately, such as logging it or showing a message to the user
      print("Error occurred: $error");
      CustomToast.errorToast('Failed to add this patient');
    } finally {
      // Ensure that isLoading is set to false regardless of whether there was an error or not
      isLoading.value = false;
    }
  }
}
