import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/custom_toast.dart';

class EditProfileController extends GetxController {
  TextEditingController phoneC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController weightC = TextEditingController();
  TextEditingController heightC = TextEditingController();

  var gender = ['Female', 'Male'];
  var selectedgender = RxString('Female');

  @override
  void onInit() async {
    super.onInit();
    _prefs = await SharedPreferences.getInstance();
    _loadUsername();
  }

  late SharedPreferences _prefs;

  var isLoading = false.obs;

  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

  Rx<DateTime> selectedDate = DateTime.now().obs;
  String? birthdate;
  void _loadUsername() {
    String username = _prefs.getString('name') ?? '';
    String phone = _prefs.getString('phone') ?? '';
    String weight = _prefs.getString('weight') ?? '';
    String height = _prefs.getString('height') ?? '';
    String birthdate = _prefs.getString('birthdate') ?? '';
    String gender = _prefs.getString('gender') ?? '';

    nameC.text = username;
    phoneC.text = phone;
    weightC.text = weight;
    heightC.text = height;
  }

  void _updateUserlocalInfo() {
    _prefs.setString('name', nameC.text);

    _prefs.setString('phone', phoneC.text);
    _prefs.setString('height', heightC.text);
    _prefs.setString('weight', weightC.text);
    _prefs.setString('gender', selectedgender.value);
    _prefs.setString('birthdate', selectedDate.value.toIso8601String());
  }

  Future<void> editProfile() async {
    isLoading.value = true;
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        DocumentReference user =
            FirebaseFirestore.instance.collection("users").doc(uid);
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();

        await user.update({
          "name": nameC.text,
          "phone": phoneC.text,
          "height": heightC.text,
          "weight": weightC.text,
          "birthdate": sharedPreferences.getString('birthdate'),
          "gender": sharedPreferences.getString('gender'),
        });

        Get.back();

        CustomToast.successToast('Your Profile Updated Successfully');
        isLoading.value = false;
      } else {
        CustomToast.errorToast('User not logged in');
      }
    } catch (e) {
      isLoading.value = false;
      CustomToast.errorToast('Error: $e');
      print('The error is $e');
    }
  }
}
