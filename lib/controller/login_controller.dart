import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/app_pages.dart';
import '../widgets/custom_toast.dart';

class LoginController extends GetxController {
  final SharedPreferences sharedPreferences;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  LoginController({required this.sharedPreferences});

  // TextEditingController phoneC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  TextEditingController passC = TextEditingController();

  var isLoading = false.obs;

  Future<void> login() async {
    isLoading.value = true;

    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      try {
        final credential = await auth.signInWithEmailAndPassword(
          email: emailC.text.trim(),
          password: passC.text.trim(),
        );
        sharedPreferences.setString('userId', auth.currentUser!.uid);

        // Get the user's email and username from Firebase Authentication
        String email = auth.currentUser!.email ?? '';

        // Store the user's email andusername in SharedPreferences
        sharedPreferences.setString('email', email);

        emailC.text = "";
        passC.text = "";
  isLoading.value = false;
        await redirectBasedOnRole();
        isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          CustomToast.errorToast("Account not found");
        } else if (e.code == 'wrong-password') {
          CustomToast.errorToast("Wrong Email or Password");
        } else {
          CustomToast.errorToast("Wrong Email or Password");
          print('the error $e');
        }
        isLoading.value = false;
      } catch (e) {
        CustomToast.errorToast("Wrong Email or Password");
        print('the error $e');
        isLoading.value = false;
      }
    } else {
      CustomToast.errorToast('Please complete all the fields');
      isLoading.value = false;
    }
  }

  Future<void> redirectBasedOnRole() async {
    // Retrieve user role from Firestore
    String? role = await getUserRole(auth.currentUser!.uid);

    if (role == 'admin') {
      // Redirect admin to admin screen
      await getAdmin();
      await Get.offAndToNamed(Routes.ADMINHOMESCREEN);
       isLoading.value = false;
    } else if (role == 'hospital' || role == 'clinic') {
      await getHospital();
      await Get.offAndToNamed(Routes.HOSPITALHOMESCREEN);
       isLoading.value = false;
    } else {
      // Redirect regular user to user screen
      await getUser();
      await Get.offAndToNamed(Routes.HOMESCREEN);
       isLoading.value = false;
    }
  }

  Future<void> getUser() async {
    String? phone;
    String? userName;
    String? email;
    String? height;
    String? weight;
    String? gender;
    String? birthdate;
    String? deviceToken;
    deviceToken = sharedPreferences.getString('deviceToken');

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get()
        .then((data) async {
      userName = data['name'];
      phone = data['phone'];
      email = data['email'];
      height = data['height'];
      weight = data['weight'];
      gender = data['gender'];
      birthdate = data['birthdate'];
      sharedPreferences.setString('name', userName!);
      sharedPreferences.setString('phone', phone!);
      sharedPreferences.setString('email', email!);
      sharedPreferences.setString('height', height!);
      sharedPreferences.setString('weight', weight!);
      sharedPreferences.setString('gender', gender!);
      sharedPreferences.setString('birthdate', birthdate!);

      // Update user document with device token
      await firestore.collection('users').doc(auth.currentUser!.uid).update({
        'userToken': deviceToken,
      });
    });
  }

  Future<void> getAdmin() async {
    String? phone;
    String? userName;
    String? email;

    String? deviceToken;
    deviceToken = sharedPreferences.getString('deviceToken');

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get()
        .then((data) async {
      userName = data['name'];
      phone = data['phone'];
      email = data['email'];

      sharedPreferences.setString('name', userName!);
      sharedPreferences.setString('phone', phone!);
      sharedPreferences.setString('email', email!);

      // Update user document with device token
      await firestore.collection('users').doc(auth.currentUser!.uid).update({
        'userToken': deviceToken,
      });
    });
  }

  Future<void> getHospital() async {
    String? phone;
    String? userName;
    String? email;

    String? deviceToken;
    deviceToken = sharedPreferences.getString('deviceToken');

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get()
        .then((data) async {
      userName = data['name'];
      phone = data['phone'];
      email = data['email'];

      sharedPreferences.setString('name', userName!);
      sharedPreferences.setString('phone', phone!);
      sharedPreferences.setString('email', email!);

      // Update user document with device token
      await firestore.collection('users').doc(auth.currentUser!.uid).update({
        'userToken': deviceToken,
      });
    });
  }

  Future<String?> getUserRole(String userId) async {
    var doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return doc.data()?['role'];
  }
}
