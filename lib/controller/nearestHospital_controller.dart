import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class NearestHospitalController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    checkLocationPermission();
  }
RxString hosName = ''.obs;
  RxString hosId = ''.obs;

  RxString hosEmail = ''.obs;
  RxString hosDeviceToken= ''.obs;
  RxString hosPhone= ''.obs;

  Map<String, dynamic>? nearestHospital;

  Future<void> checkLocationPermission() async {
    // Check if location permission is granted
    final PermissionStatus permissionStatus = await Permission.locationWhenInUse.status;

    if (permissionStatus.isGranted) {
      // If permission is granted, get current location
      _getCurrentLocation();
    } else {
      // If permission is not granted, request permission
      final PermissionStatus requestedPermissionStatus = await Permission.locationWhenInUse.request();
      if (requestedPermissionStatus.isGranted) {
        // If permission is granted after request, get current location
        _getCurrentLocation();
      } else {
        // If permission is still not granted, show a message to the user
        print("Location permission is not granted.");
      }
    }
  }
  Future<void> _getCurrentLocation() async {
    try {
      Position position;
      if (!kIsWeb) {
        var permission = await Permission.locationWhenInUse.request();
        if (permission.isGranted) {
          position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        } else {
          print('Location permission denied.');
          return;
        }
      } else {
        position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      }

      // Get all hospitals from Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'hospital').get();

      // Calculate distance for each hospital and find the nearest one
      double minDistance = double.infinity;

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        double hospitalLatitude = data['latitude'];
        double hospitalLongitude = data['longitude'];
        double distance = await Geolocator.distanceBetween(position.latitude, position.longitude, hospitalLatitude, hospitalLongitude);
        if (distance < minDistance) {
          minDistance = distance;
          nearestHospital = data;
        }
      }

      // Print details of the nearest hospital
      if (nearestHospital != null) {
        print('Nearest hospital:');
        hosName.value = nearestHospital!['name'];
        hosDeviceToken.value = nearestHospital!['userToken'] ?? "";
        hosEmail.value = nearestHospital!['email'];
        hosId.value = nearestHospital!['userId'];
        hosPhone.value = nearestHospital!['phone'];
        print('Name: ${nearestHospital!['name']}');
        print('Email: ${nearestHospital!['email']}');
        print('UserId: ${nearestHospital!['userId']}');
        print('UserToken: ${nearestHospital!['userToken']}');
        print('Phone: ${nearestHospital!['phone']}');
        print('Latitude: ${nearestHospital!['latitude']}');
        print('Longitude: ${nearestHospital!['longitude']}');
      } else {
        print('No hospitals found.');
      }

    } catch (e) {
      print('Could not get the location: $e');
    }
  }
}
