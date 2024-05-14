import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/custom_toast.dart';

class AddClinicController extends GetxController {
  final markers = <Marker>{}.obs;

  late CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(0, 0), // Default initial position
    zoom: 15,
  );

  GoogleMapController? mapController;

  @override
  void onInit() {
    super.onInit();
    _getUserLocation();
  }

  void _getUserLocation() async {
    // Check and request location permission if not granted
    PermissionStatus permissionStatus = await Permission.location.request();
    if (permissionStatus.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        initialCameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 15,
        );
      } catch (e) {
        print("Error getting user location: $e");
        // Default to a fallback location if user location is unavailable
        initialCameraPosition = CameraPosition(
          target: LatLng(37.7749, -122.4194), // Default to San Francisco coordinates
          zoom: 15,
        );
      }
    } else {
      print('Location permission is not granted');
      // Default to a fallback location if permission is not granted
      initialCameraPosition = CameraPosition(
        target: LatLng(37.7749, -122.4194), // Default to San Francisco coordinates
        zoom: 15,
      );
    }
  }

  void _updateCameraPosition(Position position) {
    final initialCameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 15,
    );
    mapController?.animateCamera(CameraUpdate.newCameraPosition(initialCameraPosition));
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void onMapTap(LatLng position) {
    markers.clear();
    markers.add(
      Marker(
        markerId: MarkerId(position.toString()),
        position: position,
      ),
    );
    selectLocation();
  }
double? selectedLatitude;
double? selectedLongitude;
  void selectLocation() {
    if (markers.isNotEmpty) {
      final selectedMarker = markers.first;
       selectedLatitude = selectedMarker.position.latitude;
       selectedLongitude = selectedMarker.position.longitude;

      // Do whatever you want with the selected latitude and longitude
      print('Selected Latitude: $selectedLatitude');
      print('Selected Longitude: $selectedLongitude');

      // You can navigate back or perform any other action here
    } else {
      // Show a message that no location is selected
      Get.snackbar(
        'Error',
        'Please select a location on the map',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  
  TextEditingController phoneC = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController passC = TextEditingController();
  TextEditingController confirmPassC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  var isLoading = false.obs;

  Future<void> createClinic() async {
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
          "name": nameC.text,
          "phone": phoneC.text,
          "email": emailC.text,
          "userId": uid,
          "createdAt": DateTime.now().toIso8601String(),
          "role": "clinic",
          "latitude":selectedLatitude,
          "longitude":selectedLongitude,
          "userToken":""
        });

        Get.back();

        CustomToast.successToast('Clinic Account Created Successfully');
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
