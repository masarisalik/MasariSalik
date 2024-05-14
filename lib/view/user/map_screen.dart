// import 'dart:async';
// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:geolocator/geolocator.dart' as geo;
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:masari_salik_app/routes/app_pages.dart';
// import 'package:masari_salik_app/style/app_color.dart';
// import 'package:masari_salik_app/style/fonts.dart';
// import 'package:masari_salik_app/view/user/startEmergency_screen.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:intl/intl.dart';

// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class FindHospitalScreen extends StatefulWidget {
//   final String complaint;
//   final String complaintType;
//   const FindHospitalScreen(
//       {Key? key, required this.complaint, required this.complaintType})
//       : super(key: key);

//   @override
//   State<FindHospitalScreen> createState() => _FindHospitalScreenState();
// }


// class _FindHospitalScreenState extends State<FindHospitalScreen> {

// Map<MarkerId, Marker> markers = {};

//     @override
//   void dispose() {

//     super.dispose();
//   }


//   LatLng? origin;

//   BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

//   String apiKey = "AIzaSyB0bpr2itiNmm-kTHahpHP4-Dj-f_4K7Ss";

//   LatLng destination = const LatLng(24.528804, 46.6498878);

//   Future<void> _checkLocationPermission() async {
//     // Check if location permission is granted
//     final PermissionStatus permissionStatus =
//         await Permission.locationWhenInUse.status;

//     if (permissionStatus.isGranted) {
//       // If permission is granted, get current location
//       _getCurrentLocation();
//     } else {
//       // If permission is not granted, request permission
//       final PermissionStatus requestedPermissionStatus =
//           await Permission.locationWhenInUse.request();
//       if (requestedPermissionStatus.isGranted) {
//         // If permission is granted after request, get current location
//         _getCurrentLocation();
//         // drawPolyline();
//       } else {
//         // If permission is still not granted, show a message to the user
//         print("Location permission is not granted.");
//       }
//     }
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       Position position;
//       if (!kIsWeb) {
//         var permission = await Permission.locationWhenInUse.request();
//         if (permission.isGranted) {
//           position = await Geolocator.getCurrentPosition(
//               desiredAccuracy: LocationAccuracy.high);
//         } else {
//           print('Location permission denied.');
//           return;
//         }
//       } else {
//         position = await Geolocator.getCurrentPosition(
//             desiredAccuracy: LocationAccuracy.high);
//       }

//       setState(() {
//         origin = LatLng(position.latitude, position.longitude);
//       });
//      await getNearestHospitalAndDrawLine(position.latitude, position.longitude);
//       // Map<String, dynamic>? nearestHospital;
//       // if (widget.complaintType == "complicated") {
//       //   // // Get all hospitals from Firestore
//       //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//       //       .collection('users')
//       //       .where('role', isEqualTo: 'hospital')
//       //       .get();

//       //   // Calculate distance for each hospital and find the nearest one
//       //   double minDistance = double.infinity;

//       //   for (QueryDocumentSnapshot doc in querySnapshot.docs) {
//       //     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//       //     double hospitalLatitude = data['latitude'];
//       //     double hospitalLongitude = data['longitude'];
//       //     double distance = await Geolocator.distanceBetween(position.latitude,
//       //         position.longitude, hospitalLatitude, hospitalLongitude);
//       //     if (distance < minDistance) {
//       //       minDistance = distance;
//       //       nearestHospital = data;
//       //     }
//       //   }
//       //   double latitude = 0.0;
//       //   double longitude = 0.0;
//       //   String name = '';
//       //   String hosId = '';
//       //   String hosPhone = '';

//       //   // Print details of the nearest hospital
//       //   if (nearestHospital != null) {
//       //     print('Nearest hospital:');
//       //     latitude = nearestHospital!['latitude'];
//       //     longitude = nearestHospital!['longitude'];
//       //     name = nearestHospital!['name'];
//       //     hosId = nearestHospital!['userId'];
//       //     hosPhone = nearestHospital!['phone'];
//       //     print('Name: ${nearestHospital!['name']}');

//       //     print('Latitude: ${nearestHospital!['latitude']}');
//       //     print('Longitude: ${nearestHospital!['longitude']}');
//       //       _addMarker(
//       //     LatLng(latitude, longitude),
//       //     name,
//       //     BitmapDescriptor.defaultMarkerWithHue(90),
//       //     () {
//       //       _showBottomSheet(context, name, hosId, hosPhone);
//       //     },
//       //   );
//       //   } else {
//       //     print('No hospitals found.');
//       //   }
      
//       //   // Fetch hospital data from Firebase
//       // //    double latitude = 0.0;
//       // //   double longitude = 0.0;
//       // // FirebaseFirestore.instance
//       // //     .collection('users')
//       // //     .where('role', isEqualTo: 'hospital')
//       // //     .get()
//       // //     .then((querySnapshot) {
//       // //   querySnapshot.docs.forEach((doc) {
//       // //     // Extract hospital information
//       // //      latitude = doc['latitude'];
//       // //      longitude = doc['longitude'];
//       // //     String name = doc['name'];
//       // //     String id = doc['userId'];
//       // //     String phone = doc['phone'];
      
//       // //     // Add marker for each hospital
//       // //     _addMarker(
//       // //       LatLng(latitude, longitude),
//       // //       name,
//       // //       BitmapDescriptor.defaultMarkerWithHue(90),
//       // //           () {
//       // //         _showBottomSheet(context, name, id, phone);
//       // //       },
//       // //     );
//       // //   });
//       // // });
//       //   drawPolyline(latitude, longitude);
//       // } else {
//       //   // Get all hospitals from Firestore
//       //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//       //       .collection('users')
//       //       .where('role', isEqualTo: 'clinic')
//       //       .get();

//       //   // Calculate distance for each hospital and find the nearest one
//       //   double minDistance = double.infinity;

//       //   for (QueryDocumentSnapshot doc in querySnapshot.docs) {
//       //     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//       //     double hospitalLatitude = data['latitude'];
//       //     double hospitalLongitude = data['longitude'];
//       //     double distance = await Geolocator.distanceBetween(position.latitude,
//       //         position.longitude, hospitalLatitude, hospitalLongitude);
//       //     if (distance < minDistance) {
//       //       minDistance = distance;
//       //       nearestHospital = data;
//       //     }
//       //   }
//       //   double latitude = 0.0;
//       //   double longitude = 0.0;
//       //   String name = '';
//       //   String hosId = '';
//       //   String hosPhone = '';
//       //   // Print details of the nearest hospital
//       //   if (nearestHospital != null) {
//       //     print('Nearest hospital:');
//       //     latitude = nearestHospital!['latitude'];
//       //     longitude = nearestHospital!['longitude'];

//       //     name = nearestHospital!['name'];
//       //     hosId = nearestHospital!['userId'];
//       //     hosPhone = nearestHospital!['phone'];
//       //     print('Name: ${nearestHospital!['name']}');

//       //     print('Latitude: ${nearestHospital!['latitude']}');
//       //     print('Longitude: ${nearestHospital!['longitude']}');
//       //      _addMarker(
//       //     LatLng(latitude, longitude),
//       //     name,
//       //     BitmapDescriptor.defaultMarkerWithHue(90),
//       //     () {
//       //       _showBottomSheet(context, name, hosId, hosPhone);
//       //     },
//       //   );
//       //   } else {
//       //     print('No hospitals found.');
//       //   }
       
//       //   drawPolyline(latitude, longitude);
//       // }
// // Add markers for all hospitals
//   //  await _addMarkersForHospitals(position.latitude, position.longitude);

//     } catch (e) {
//       print('Could not get the location: $e');
//     }
//   }
// Future<void> _addMarkersForHospitals(double userLatitude, double userLongitude) async {
//   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//       .collection('users')
//       .where('role', isEqualTo: 'hospital')
//       .get();

//   querySnapshot.docs.forEach((doc) {
//     double hospitalLatitude = doc['latitude'];
//     double hospitalLongitude = doc['longitude'];
//     String name = doc['name'];
//     // Add marker for each hospital
//      setState(() {
//     _addMarker(
//       LatLng(hospitalLatitude, hospitalLongitude),
//       name,
//       BitmapDescriptor.defaultMarkerWithHue(90), // You can adjust marker appearance here
//       () {
//         // You can add any functionality you want when a marker is tapped
//         print('Marker tapped: $name');
//       },
//     );
//   });
//   });
// }





// getNearestHospitalAndDrawLine(double personLat, double personLong)async{
//   Map<String, dynamic>? nearestHospital;
//       if (widget.complaintType == "complicated") {
//         // // // Get all hospitals from Firestore
//         // QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         //     .collection('users')
//         //     .where('role', isEqualTo: 'hospital')
//         //     .get();

//         // // Calculate distance for each hospital and find the nearest one
//         // double minDistance = double.infinity;

//         // for (QueryDocumentSnapshot doc in querySnapshot.docs) {
//         //   Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//         //   double hospitalLatitude = data['latitude'];
//         //   double hospitalLongitude = data['longitude'];
//         //   double distance = await Geolocator.distanceBetween(personLat,
//         //     personLong, hospitalLatitude, hospitalLongitude);
//         //   if (distance < minDistance) {
//         //     minDistance = distance;
//         //     nearestHospital = data;
//         //   }
//         // }
//         // double latitude = 0.0;
//         // double longitude = 0.0;
//         // String name = '';
//         // String hosId = '';
//         // String hosPhone = '';

//         // // Print details of the nearest hospital
//         // if (nearestHospital != null) {
//         //   print('Nearest hospital:');
//         //   latitude = nearestHospital!['latitude'];
//         //   longitude = nearestHospital!['longitude'];
//         //   name = nearestHospital!['name'];
//         //   hosId = nearestHospital!['userId'];
//         //   hosPhone = nearestHospital!['phone'];
//         //   print('Name: ${nearestHospital!['name']}');

//         //   print('Latitude: ${nearestHospital!['latitude']}');
//         //   print('Longitude: ${nearestHospital!['longitude']}');
//         //     _addMarker(
//         //   LatLng(latitude, longitude),
//         //   name,
//         //   BitmapDescriptor.defaultMarkerWithHue(90),
//         //   () {
//         //     _showBottomSheet(context, name, hosId, hosPhone);
//         //   },
//         // );
//         // } else {
//         //   print('No hospitals found.');
//         // }
      
//         // drawPolyline(latitude, longitude);



//          QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'hospital').get();

//       // Calculate distance for each hospital and find the nearest one
//       double minDistance = double.infinity;

//       for (QueryDocumentSnapshot doc in querySnapshot.docs) {
//         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//         double hospitalLatitude = data['latitude'];
//         double hospitalLongitude = data['longitude'];
//         double distance = await Geolocator.distanceBetween(personLat,
//             personLong, hospitalLatitude, hospitalLongitude);
//         if (distance < minDistance) {
//           minDistance = distance;
//           nearestHospital = data;
//         }
//       }
//         double latitude = 0.0;
//         double longitude = 0.0;
//         String name = '';
//         String hosId = '';
//         String hosPhone = '';
//       // Print details of the nearest hospital
//       if (nearestHospital != null) {
//         print('Nearest hospital:');
//        name = nearestHospital!['name'];
//        latitude = nearestHospital!['latitude'] ?? "";
//         longitude = nearestHospital!['longitude'];
//         hosId = nearestHospital!['userId'];
//        hosPhone = nearestHospital!['phone'];
//         print('Name: ${nearestHospital!['name']}');
//         print('Email: ${nearestHospital!['email']}');
//         print('UserId: ${nearestHospital!['userId']}');
//         print('UserToken: ${nearestHospital!['userToken']}');
//         print('Phone: ${nearestHospital!['phone']}');
//         print('Latitude: ${nearestHospital!['latitude']}');
//         print('Longitude: ${nearestHospital!['longitude']}');

              
      

//       } else {
//         print('No hospitals found.');
//       }
//       _addMarker(
//           LatLng(latitude, longitude),
//           name,
//           BitmapDescriptor.defaultMarkerWithHue(90),
//           () {
//             _showBottomSheet(context, name, hosId, hosPhone);
//           },
//         );
//   drawPolyline(latitude, longitude);
//       } else {
//         // Get all hospitals from Firestore
//         QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//             .collection('users')
//             .where('role', isEqualTo: 'clinic')
//             .get();

//         // Calculate distance for each hospital and find the nearest one
//         double minDistance = double.infinity;

//         for (QueryDocumentSnapshot doc in querySnapshot.docs) {
//           Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//           double hospitalLatitude = data['latitude'];
//           double hospitalLongitude = data['longitude'];
//           double distance = await Geolocator.distanceBetween(personLong,
//               personLong, hospitalLatitude, hospitalLongitude);
//           if (distance < minDistance) {
//             minDistance = distance;
//             nearestHospital = data;
//           }
//         }
//         double latitude = 0.0;
//         double longitude = 0.0;
//         String name = '';
//         String hosId = '';
//         String hosPhone = '';
//         // Print details of the nearest hospital
//         if (nearestHospital != null) {
//           print('Nearest hospital:');
//           latitude = nearestHospital!['latitude'];
//           longitude = nearestHospital!['longitude'];

//           name = nearestHospital!['name'];
//           hosId = nearestHospital!['userId'];
//           hosPhone = nearestHospital!['phone'];
//           print('Name: ${nearestHospital!['name']}');

//           print('Latitude: ${nearestHospital!['latitude']}');
//           print('Longitude: ${nearestHospital!['longitude']}');
//            _addMarker(
//           LatLng(latitude, longitude),
//           name,
//           BitmapDescriptor.defaultMarkerWithHue(90),
//           () {
//             _showBottomSheet(context, name, hosId, hosPhone);
//           },
//         );
//         } else {
//           print('No hospitals found.');
//         }
       
//         drawPolyline(latitude, longitude);
//       }

// }




//   @override
//   void initState() {
//     _checkLocationPermission();

//     _initializeState();
//       //  double latitude = 0.0;
//       //   double longitude = 0.0;
//       // FirebaseFirestore.instance
//       //     .collection('users')
//       //     .where('role', isEqualTo: 'hospital')
//       //     .get()
//       //     .then((querySnapshot) {
//       //   querySnapshot.docs.forEach((doc) {
//       //     // Extract hospital information
//       //      latitude = doc['latitude'];
//       //      longitude = doc['longitude'];
//       //     String name = doc['name'];
//       //     String id = doc['userId'];
//       //     String phone = doc['phone'];
      
//       //     // Add marker for each hospital
//       //     _addMarker(
//       //       LatLng(latitude, longitude),
//       //       name,
//       //       BitmapDescriptor.defaultMarkerWithHue(90),
//       //           () {
//       //         _showBottomSheet(context, name, id, phone);
//       //       },
//       //     );
//       //   });
//       // });



//       /////////////////////////////////////
    

    
//     super.initState();
//   }

//   void _initializeState() {
//     SharedPreferences.getInstance().then((prefs) {
//       _prefs = prefs;
//       _loadUsername();

    
//     });
//   }

//   late SharedPreferences _prefs;
//   String username = '';
//   String phone = '';
//   String weight = '';
//   String height = '';
//   String birthdate = '';
//   String gender = '';
//   void _loadUsername() {
//     username = _prefs.getString('name') ?? '';
//     phone = _prefs.getString('phone') ?? '';
//     weight = _prefs.getString('weight') ?? '';
//     height = _prefs.getString('height') ?? '';
//     birthdate = _prefs.getString('birthdate') ?? '';
//     gender = _prefs.getString('gender') ?? '';
//   }



//   _addMarker(
//       LatLng position, String id, BitmapDescriptor descriptor, Function onTap) {
//     MarkerId markerId = MarkerId(id);
//     Marker marker = Marker(
//       markerId: markerId,
//       icon: descriptor,
//       position: position,
//       onTap: () {
//         onTap();
//       },
//     );
//     markers[markerId] = marker;
//   }

//   final Completer<GoogleMapController> _controller = Completer();

//   String totalDistance = "";
//   String totalTime = "";

//   PolylineResponse polylineResponse = PolylineResponse();
//   Set<Polyline> polylinePoints = {};

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Location",
//           style: robotodarkHuge,
//         ),
//         centerTitle: true,
//         iconTheme: IconThemeData(color: AppColor.primary),
//         backgroundColor: AppColor.primarySoft,
//         shape: ContinuousRectangleBorder(
//           borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(30),
//             bottomRight: Radius.circular(30),
//           ),
//         ),
//       ),
//       body: Stack(
//         children: [
//           origin != null
//               ? Container(
//                   child: GoogleMap(
//                     polylines: polylinePoints,
//                     zoomControlsEnabled: false,
//                     initialCameraPosition: CameraPosition(
//                       target: origin!,
//                       zoom: 18,
//                     ),
//                     mapType: MapType.normal,
//                     markers: Set<Marker>.of(markers.values),
//                     myLocationEnabled: true,
//                     myLocationButtonEnabled: true,
//                     onMapCreated: (GoogleMapController controller) {
//                       _controller.complete(controller);
//                     },
//                   ),
//                 )
//               : Center(
//                   child: CircularProgressIndicator(), // Loading indicator
//                 ),
//         ],
//       ),
//       bottomSheet: _buildPersistentBottomSheet(context),
//     );
//   }

//   void drawPolyline(double hoslatitude, double hoslongitude) async {
//     var response = await http.post(Uri.parse(
//         "https://maps.googleapis.com/maps/api/directions/json?key=" +
//             apiKey +
//             "&units=metric&origin=" +
//             origin!.latitude.toString() +
//             "," +
//             origin!.longitude.toString() +
//             "&destination=" +
//             hoslatitude.toString() +
//             "," +
//             hoslongitude.toString() +
//             "&mode=driving"));

//     print(response.body);

//     polylineResponse = PolylineResponse.fromJson(jsonDecode(response.body));

//     totalDistance = polylineResponse.routes![0].legs![0].distance!.text!;
//     totalTime = polylineResponse.routes![0].legs![0].duration!.text!;

//     for (int i = 0;
//         i < polylineResponse.routes![0].legs![0].steps!.length;
//         i++) {
//       polylinePoints.add(Polyline(
//           polylineId: PolylineId(
//               polylineResponse.routes![0].legs![0].steps![i].polyline!.points!),
//           points: [
//             LatLng(
//                 polylineResponse
//                     .routes![0].legs![0].steps![i].startLocation!.lat!,
//                 polylineResponse
//                     .routes![0].legs![0].steps![i].startLocation!.lng!),
//             LatLng(
//                 polylineResponse
//                     .routes![0].legs![0].steps![i].endLocation!.lat!,
//                 polylineResponse
//                     .routes![0].legs![0].steps![i].endLocation!.lng!),
//           ],
//           width: 6,
//           color: Colors.blue));
//     }

//     setState(() {});
//   }

//   void _showBottomSheet(
//       BuildContext context, String name, String id, String phone) async {
//     String? address =
//         await _getDestinationAddress(); // Fetch destination address

//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           height: 270,
//           decoration: BoxDecoration(
//             color: AppColor.primary,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20.0),
//               topRight: Radius.circular(20.0),
//             ),
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: AppColor.whiteColor,
//                       borderRadius: BorderRadius.circular(20.0),
//                     ),
//                     child: SizedBox(
//                       width: 50,
//                       height: 5,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: AppColor.whiteColor,
//                       borderRadius: BorderRadius.circular(20.0),
//                     ),
//                     child: ListTile(
//                       title: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             name,
//                             style: robotodarkHuge,
//                           ),
//                           Container(
//                             decoration: BoxDecoration(
//                               color: AppColor.primarySoft,
//                               borderRadius: BorderRadius.circular(16.0),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 "Need Help",
//                                 style: robotoMediumWhite,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       leading: CircleAvatar(
//                         backgroundColor: AppColor.primary,
//                         child: Icon(
//                           Icons.local_hospital_rounded,
//                           color: AppColor.primarySoft,
//                         ),
//                       ),
//                       trailing: Icon(
//                         Icons.list,
//                         color: AppColor.primary,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Text(
//                   "Need Help",
//                   style: robotoHugeWhite,
//                 ),
//                 Text(
//                   address ??
//                       "Address not available", // Display destination address
//                   style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   DateFormat('EEEE, dd MMMM hh:mm:ss a').format(DateTime.now()),
//                   style: robotoHugeWhite,
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ListTile(
//                         leading: Icon(
//                           Icons.phone,
//                           color: AppColor.primarySoft,
//                         ),
//                         title: FittedBox(
//                           child: Text(
//                             phone,
//                             style: robotoMediumLightBold,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             onPressed: () async {
//                               DateTime now = DateTime.now();
//                               String formattedDate =
//                                   DateFormat('dd/MM/yyyy/ hh:mm a').format(now);
//                               DocumentReference user = FirebaseFirestore
//                                   .instance
//                                   .collection("operations")
//                                   .doc();
//                               await user.set({
//                                 "name": username,
//                                 "phone": phone,
//                                 "userId":
//                                     FirebaseAuth.instance.currentUser!.uid,
//                                 "date": formattedDate,
//                                 "height": height,
//                                 "weight": weight,
//                                 "birthdate": birthdate,
//                                 "gender": gender,
//                                 'hospitalId': id,
//                                 'complaint': widget.complaint
//                               });
//                               Get.to(StartEmergencyScreen());
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColor.primarySoft,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10.0),
//                               ),
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 30,
//                                 vertical: 10,
//                               ),
//                             ),
//                             child: Text(
//                               "Call Hospital",
//                               style: robotodarkHuge,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildPersistentBottomSheet(BuildContext context) {
//     return Container(
//       height: 120,
//       decoration: BoxDecoration(
//         color: AppColor.primary,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20.0),
//           topRight: Radius.circular(20.0),
//         ),
//       ),
//       child: FutureBuilder<String?>(
//         future: _getAddress(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasData) {
//             return Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white, // Adjust opacity as needed
//                       borderRadius: BorderRadius.circular(20.0),
//                     ),
//                     child: SizedBox(
//                       width: 50,
//                       height: 5,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white, // Adjust opacity as needed
//                       borderRadius: BorderRadius.circular(20.0),
//                     ),
//                     child: ListTile(
//                       title: Text(
//                         "My Position",
//                         style: robotodarkHuge,
//                       ),
//                       subtitle: FittedBox(
//                         child: Text(
//                           snapshot.data!,
//                           style: robotoMediumLightBold,
//                         ),
//                       ),
//                       trailing: CircleAvatar(
//                           backgroundColor: AppColor.primary,
//                           child: Icon(
//                             Icons.telegram_rounded,
//                             color: AppColor.primarySoft,
//                           )),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           }
//           return SizedBox();
//         },
//       ),
//     );
//   }

//   Future<String?> _getAddress() async {
//     try {
//       List<Placemark> placemarks =
//           await placemarkFromCoordinates(origin!.latitude, origin!.longitude);
//       Placemark place = placemarks.first;
//       return "${place.street}, ${place.locality}, ${place.country}";
//     } catch (e) {
//       return "----------------";
//     }
//   }

//   Future<String?> _getDestinationAddress() async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//           destination.latitude, destination.longitude);
//       Placemark place = placemarks.first;
//       return "${place.street}, ${place.locality}, ${place.country}";
//     } catch (e) {
//       return "--------------";
//     }
//   }
// }

// class PolylineResponse {
//   List<GeocodedWaypoints>? geocodedWaypoints;
//   List<Routes>? routes;
//   String? status;

//   PolylineResponse({this.geocodedWaypoints, this.routes, this.status});

//   PolylineResponse.fromJson(Map<String, dynamic> json) {
//     if (json['geocoded_waypoints'] != null) {
//       geocodedWaypoints = <GeocodedWaypoints>[];
//       json['geocoded_waypoints'].forEach((v) {
//         geocodedWaypoints!.add(GeocodedWaypoints.fromJson(v));
//       });
//     }
//     if (json['routes'] != null) {
//       routes = <Routes>[];
//       json['routes'].forEach((v) {
//         routes!.add(Routes.fromJson(v));
//       });
//     }
//     status = json['status'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (geocodedWaypoints != null) {
//       data['geocoded_waypoints'] =
//           geocodedWaypoints!.map((v) => v.toJson()).toList();
//     }
//     if (routes != null) {
//       data['routes'] = routes!.map((v) => v.toJson()).toList();
//     }
//     data['status'] = status;
//     return data;
//   }
// }

// class GeocodedWaypoints {
//   String? geocoderStatus;
//   String? placeId;
//   List<String>? types;

//   GeocodedWaypoints({this.geocoderStatus, this.placeId, this.types});

//   GeocodedWaypoints.fromJson(Map<String, dynamic> json) {
//     geocoderStatus = json['geocoder_status'];
//     placeId = json['place_id'];
//     types = json['types'].cast<String>();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['geocoder_status'] = geocoderStatus;
//     data['place_id'] = placeId;
//     data['types'] = types;
//     return data;
//   }
// }

// class Routes {
//   Bounds? bounds;
//   String? copyrights;
//   List<Legs>? legs;
//   PolylineModel? overviewPolyline;
//   String? summary;

//   Routes(
//       {this.bounds,
//       this.copyrights,
//       this.legs,
//       this.overviewPolyline,
//       this.summary});

//   Routes.fromJson(Map<String, dynamic> json) {
//     bounds = json['bounds'] != null ? Bounds.fromJson(json['bounds']) : null;
//     copyrights = json['copyrights'];
//     if (json['legs'] != null) {
//       legs = <Legs>[];
//       json['legs'].forEach((v) {
//         legs!.add(Legs.fromJson(v));
//       });
//     }
//     overviewPolyline = json['overview_polyline'] != null
//         ? PolylineModel.fromJson(json['overview_polyline'])
//         : null;
//     summary = json['summary'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (bounds != null) {
//       data['bounds'] = bounds!.toJson();
//     }
//     data['copyrights'] = copyrights;
//     if (legs != null) {
//       data['legs'] = legs!.map((v) => v.toJson()).toList();
//     }
//     if (overviewPolyline != null) {
//       data['overview_polyline'] = overviewPolyline!.toJson();
//     }
//     data['summary'] = summary;
//     return data;
//   }
// }

// class Bounds {
//   Northeast? northeast;
//   Northeast? southwest;

//   Bounds({this.northeast, this.southwest});

//   Bounds.fromJson(Map<String, dynamic> json) {
//     northeast = json['northeast'] != null
//         ? Northeast.fromJson(json['northeast'])
//         : null;
//     southwest = json['southwest'] != null
//         ? Northeast.fromJson(json['southwest'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (northeast != null) {
//       data['northeast'] = northeast!.toJson();
//     }
//     if (southwest != null) {
//       data['southwest'] = southwest!.toJson();
//     }
//     return data;
//   }
// }

// class Northeast {
//   double? lat;
//   double? lng;

//   Northeast({this.lat, this.lng});

//   Northeast.fromJson(Map<String, dynamic> json) {
//     lat = json['lat'];
//     lng = json['lng'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['lat'] = lat;
//     data['lng'] = lng;
//     return data;
//   }
// }

// class Legs {
//   Distance? distance;
//   Distance? duration;
//   String? endAddress;
//   Northeast? endLocation;
//   String? startAddress;
//   Northeast? startLocation;
//   List<Steps>? steps;

//   Legs(
//       {this.distance,
//       this.duration,
//       this.endAddress,
//       this.endLocation,
//       this.startAddress,
//       this.startLocation,
//       this.steps});

//   Legs.fromJson(Map<String, dynamic> json) {
//     distance =
//         json['distance'] != null ? Distance.fromJson(json['distance']) : null;
//     duration =
//         json['duration'] != null ? Distance.fromJson(json['duration']) : null;
//     endAddress = json['end_address'];
//     endLocation = json['end_location'] != null
//         ? Northeast.fromJson(json['end_location'])
//         : null;
//     startAddress = json['start_address'];
//     startLocation = json['start_location'] != null
//         ? Northeast.fromJson(json['start_location'])
//         : null;
//     if (json['steps'] != null) {
//       steps = <Steps>[];
//       json['steps'].forEach((v) {
//         steps!.add(Steps.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (distance != null) {
//       data['distance'] = distance!.toJson();
//     }
//     if (duration != null) {
//       data['duration'] = duration!.toJson();
//     }
//     data['end_address'] = endAddress;
//     if (endLocation != null) {
//       data['end_location'] = endLocation!.toJson();
//     }
//     data['start_address'] = startAddress;
//     if (startLocation != null) {
//       data['start_location'] = startLocation!.toJson();
//     }
//     if (steps != null) {
//       data['steps'] = steps!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Distance {
//   String? text;
//   int? value;

//   Distance({this.text, this.value});

//   Distance.fromJson(Map<String, dynamic> json) {
//     text = json['text'];
//     value = json['value'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['text'] = text;
//     data['value'] = value;
//     return data;
//   }
// }

// class Steps {
//   Distance? distance;
//   Distance? duration;
//   Northeast? endLocation;
//   String? htmlInstructions;
//   PolylineModel? polyline;
//   Northeast? startLocation;
//   String? travelMode;
//   String? maneuver;

//   Steps(
//       {this.distance,
//       this.duration,
//       this.endLocation,
//       this.htmlInstructions,
//       this.polyline,
//       this.startLocation,
//       this.travelMode,
//       this.maneuver});

//   Steps.fromJson(Map<String, dynamic> json) {
//     distance =
//         json['distance'] != null ? Distance.fromJson(json['distance']) : null;
//     duration =
//         json['duration'] != null ? Distance.fromJson(json['duration']) : null;
//     endLocation = json['end_location'] != null
//         ? Northeast.fromJson(json['end_location'])
//         : null;
//     htmlInstructions = json['html_instructions'];
//     polyline = json['polyline'] != null
//         ? PolylineModel.fromJson(json['polyline'])
//         : null;
//     startLocation = json['start_location'] != null
//         ? Northeast.fromJson(json['start_location'])
//         : null;
//     travelMode = json['travel_mode'];
//     maneuver = json['maneuver'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (distance != null) {
//       data['distance'] = distance!.toJson();
//     }
//     if (duration != null) {
//       data['duration'] = duration!.toJson();
//     }
//     if (endLocation != null) {
//       data['end_location'] = endLocation!.toJson();
//     }
//     data['html_instructions'] = htmlInstructions;
//     if (polyline != null) {
//       data['polyline'] = polyline!.toJson();
//     }
//     if (startLocation != null) {
//       data['start_location'] = startLocation!.toJson();
//     }
//     data['travel_mode'] = travelMode;
//     data['maneuver'] = maneuver;
//     return data;
//   }
// }

// class PolylineModel {
//   String? points;

//   PolylineModel({this.points});

//   PolylineModel.fromJson(Map<String, dynamic> json) {
//     points = json['points'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['points'] = points;
//     return data;
//   }
// }
