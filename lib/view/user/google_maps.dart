import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:masari_salik_app/style/app_color.dart';
import 'package:masari_salik_app/style/fonts.dart';
import 'package:masari_salik_app/view/user/startEmergency_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';

class HospitalMapScreen extends StatefulWidget {
  final String complaint;
  final String complaintType;
  const HospitalMapScreen(
      {Key? key, required this.complaint, required this.complaintType})
      : super(key: key);

  @override
  _HospitalMapScreenState createState() => _HospitalMapScreenState();
}

class _HospitalMapScreenState extends State<HospitalMapScreen> {
  late GoogleMapController mapController;
  Position? currentPosition;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  List<DocumentSnapshot> hospitals = [];
  LatLng? destination;
  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _getHospitals();
    _addMarkers();
    _initializeState();
  }

  late SharedPreferences _prefs;

  void _initializeState() {
    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
      _loadUsername();
    });
  }

  String username = '';
  String phone = '';
  String weight = '';
  String height = '';
  String birthdate = '';
  String gender = '';
  void _loadUsername() {
    username = _prefs.getString('name') ?? '';
    phone = _prefs.getString('phone') ?? '';
    weight = _prefs.getString('weight') ?? '';
    height = _prefs.getString('height') ?? '';
    birthdate = _prefs.getString('birthdate') ?? '';
    gender = _prefs.getString('gender') ?? '';
  }

  void _getUserLocation() async {
    // Check if location permission is granted
    var permissionStatus = await Permission.location.status;
    if (permissionStatus.isGranted) {
      // Permission is granted, get the user's current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        currentPosition = position;
        _addMarkers();
      });
    } else {
      // If permission is not granted, request it
      if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
        await Permission.location.request();
      }
      // After requesting permission, check again
      permissionStatus = await Permission.location.status;
      if (permissionStatus.isGranted) {
        // Permission granted, get the user's location
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          currentPosition = position;
        });
      } else {
        // Permission still not granted, handle it accordingly
        // For example, show an error message or disable location-based features
      }
    }
  }

  void _getHospitals() async {
    if (widget.complaintType == "complicated") {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'hospital')
          .get();
      setState(() {
        hospitals = snapshot.docs;
      });
      _addMarkers();
    } else {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'clinic')
          .get();
      setState(() {
        hospitals = snapshot.docs;
      });
      _addMarkers();
    }
  }

  // void _addMarkers() {
  //   // Draw initial polyline to the nearest hospital
  //   var nearestHospital = _findNearestHospital();
  //   if (nearestHospital != null && currentPosition != null) {
  //     var data = nearestHospital.data() as Map<String, dynamic>?;
  //     if (data != null) {
  //       var lat = data['latitude'];
  //       var lng = data['longitude'];
  //       if (lat != null && lng != null) {
  //         polylines.add(Polyline(
  //           polylineId: PolylineId('NearestHospital'),
  //           color: AppColor.primary,
  //           width: 3,
  //           points: [
  //             LatLng(currentPosition!.latitude, currentPosition!.longitude),
  //             LatLng(lat, lng),
  //           ],
  //         ));
  //       }
  //     }
  //   }

  //   // Add markers for all hospitals
  //   for (var hospital in hospitals) {
  //     var data = hospital.data() as Map<String, dynamic>?;
  //     if (data != null) {
  //       var lat = data['latitude'];
  //       var lng = data['longitude'];
  //       var name = data['name'];
  //       var phone = data['phone'];
  //       var hosId = data['userId'];
  //       if (lat != null && lng != null && name != null) {
  //         var marker = Marker(
  //           markerId: MarkerId(hospital.id),
  //           position: LatLng(lat, lng),
  //           infoWindow: InfoWindow(title: name),
  //           onTap: () {
  //             _handleMarkerTap(hospital);

  //           },
  //         );
  //         markers.add(marker);
  //       }
  //     }
  //   }
  // }

  void _addMarkers() {
    // Draw initial polyline to the nearest hospital
    var nearestHospital = _findNearestHospital();
    if (nearestHospital != null && currentPosition != null) {
      var data = nearestHospital.data() as Map<String, dynamic>?;
      if (data != null) {
        var lat = data['latitude'];
        var lng = data['longitude'];
        if (lat != null && lng != null) {
          // Draw polyline to nearest hospital
          drawPolyline(lat, lng);
        }
      }
    }

    // Add markers for all hospitals
    for (var hospital in hospitals) {
      var data = hospital.data() as Map<String, dynamic>?;
      if (data != null) {
        var lat = data['latitude'];
        var lng = data['longitude'];
        var name = data['name'];
        if (lat != null && lng != null && name != null) {
          var marker = Marker(
            markerId: MarkerId(hospital.id),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: name),
            onTap: () {
              _handleMarkerTap(hospital);
            },
          );
          markers.add(marker);
        }
      }
    }
  }

  void drawPolyline(double hoslatitude, double hoslongitude) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyB0bpr2itiNmm-kTHahpHP4-Dj-f_4K7Ss", // Your Google Maps API Key
      PointLatLng(currentPosition!.latitude, currentPosition!.longitude),
      PointLatLng(hoslatitude, hoslongitude),
    );

    if (result.errorMessage!.isEmpty) {
      if (result.points.isNotEmpty) {
        // Extract polyline points
        List<LatLng> points = result.points.map((point) {
          return LatLng(point.latitude, point.longitude);
        }).toList();

        // Add polyline to the map
        setState(() {
          polylines.add(Polyline(
            polylineId: PolylineId('route'),
            points: points,
            color: Colors.blue,
            width: 6,
          ));
        });
      }
    } else {
      print("No route found: ${result.errorMessage}");
      // You can display a message to the user indicating no route is found.
    }
  }

  void _handleMarkerTap(DocumentSnapshot tappedHospital) {
    var data = tappedHospital.data() as Map<String, dynamic>?;
    if (data != null && currentPosition != null) {
      var lat = data['latitude'];
      var lng = data['longitude'];
      var name = data['name'];
      var phone = data['phone'];
      var hosId = data['userId'];
      var hosToken = data['userToken'] ?? '';
      if (lat != null && lng != null) {
        // Clear existing polylines
        setState(() {
          // destination! == LatLng(lat, lng);
          polylines.clear();
        });
        print("$name, $hosId, $phone, $lat");
        _showBottomSheet(context, name, hosId, phone, lat, lng, hosToken);
        // Draw new polyline from user's location to tapped hospital
        // polylines.add(Polyline(
        //   polylineId: PolylineId('NewPolyline'),
        //   color: AppColor.primary,
        //   width: 4,
        //   points: [
        //     LatLng(currentPosition!.latitude, currentPosition!.longitude),
        //     LatLng(lat, lng),
        //   ],
        // ));
        drawPolyline(lat, lng);
      }
    }
  }

  DocumentSnapshot? _findNearestHospital() {
    double minDistance = double.infinity;
    DocumentSnapshot? nearestHospital;
    for (var hospital in hospitals) {
      var data = hospital.data() as Map<String, dynamic>?;
      if (data != null && currentPosition != null) {
        var lat = data['latitude'];
        var lng = data['longitude'];
        if (lat != null && lng != null) {
          double distance = Geolocator.distanceBetween(
              currentPosition!.latitude, currentPosition!.longitude, lat, lng);
          if (distance < minDistance) {
            minDistance = distance;
            nearestHospital = hospital;
          }
        }
      }
    }
    return nearestHospital;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Location",
          style: robotodarkHuge,
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColor.primary),
        backgroundColor: AppColor.primarySoft,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
      ),
      body: Stack(
        children: [
          currentPosition == null
              ? Center(
                  child: CircularProgressIndicator(
                  color: AppColor.primary,
                ))
              : Container(
                  // Wrap GoogleMap with Expanded
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(currentPosition!.latitude,
                          currentPosition!.longitude),
                      zoom: 12,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                    },
                    markers: markers,
                    polylines: polylines,
                  ),
                ),
        ],
      ),
      bottomSheet: _buildPersistentBottomSheet(context),
    );
  }

  Future<String?> _getAddress() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentPosition!.latitude, currentPosition!.longitude);
      Placemark place = placemarks.first;
      return "${place.street}, ${place.locality}, ${place.country}";
    } catch (e) {
      return "";
    }
  }

  Widget _buildPersistentBottomSheet(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: FutureBuilder<String?>(
        future: _getAddress(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: AppColor.primarySoft,
            ));
          }
          if (snapshot.hasData) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Adjust opacity as needed
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: SizedBox(
                      width: 50,
                      height: 5,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Adjust opacity as needed
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: ListTile(
                      title: Text(
                        "My Position",
                        style: robotodarkHuge,
                      ),
                      subtitle: Text(
                        snapshot.data!,
                        style: robotoMediumLightBold,
                      ),
                      trailing: CircleAvatar(
                          backgroundColor: AppColor.primary,
                          child: Icon(
                            Icons.telegram_rounded,
                            color: AppColor.primarySoft,
                          )),
                    ),
                  ),
                ),
              ],
            );
          }
          return SizedBox();
        },
      ),
    );
  }

  void _showBottomSheet(BuildContext context, String name, String id,
      String phone, double lat, double lng, String hosToken) async {
    String? address =
        await _getDestinationAddress(lat, lng); // Fetch destination address

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 270,
          decoration: BoxDecoration(
            color: AppColor.primary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: SizedBox(
                      width: 50,
                      height: 5,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: ListTile(
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: robotoMediumBold,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColor.primarySoft,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Need Help",
                                style: robotoMediumWhite,
                              ),
                            ),
                          ),
                        ],
                      ),
                      leading: CircleAvatar(
                        backgroundColor: AppColor.primary,
                        child: Icon(
                          Icons.local_hospital_rounded,
                          color: AppColor.primarySoft,
                        ),
                      ),
                      trailing: Icon(
                        Icons.list,
                        color: AppColor.primary,
                      ),
                    ),
                  ),
                ),
                Text(
                  "Need Help",
                  style: robotoHugeWhite,
                ),
                Text(
                  address ?? "", // Display destination address
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  DateFormat('EEEE, dd MMMM hh:mm:ss a').format(DateTime.now()),
                  style: robotoHugeWhite,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        leading: Icon(
                          Icons.phone,
                          color: AppColor.primarySoft,
                        ),
                        title: InkWell(
                          onTap: () => _callEmergencyNumber(phone),
                          child: FittedBox(
                            child: Text(
                              phone,
                              style: robotoMediumLightBold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              DateTime now = DateTime.now();
                              String formattedDate2 =
                                  formatDate(now, 'dd MM yyyy');

                              String formattedDate =
                                  DateFormat('dd/MM/yyyy/ hh:mm a').format(now);
                              DocumentReference user = FirebaseFirestore
                                  .instance
                                  .collection("operations")
                                  .doc();
                              await user.set({
                                "name": username,
                                "phone": phone,
                                "userId":
                                    FirebaseAuth.instance.currentUser!.uid,
                                "date": formattedDate,
                                "height": height,
                                "weight": weight,
                                "birthdate": birthdate,
                                "gender": gender,
                                'hospitalId': id,
                                'complaint': widget.complaint,
                                'operationDate': formattedDate2
                              });
                              updateAlertValue();
                              sendPushMessage('hospital', hosToken);
                              Get.to(StartEmergencyScreen());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primarySoft,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 10,
                              ),
                            ),
                            child: Text(
                              "Call Hospital",
                              style: robotodarkHuge,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String formatDate(DateTime dateTime, String format) {
    final formatter = DateFormat(format);
    return formatter.format(dateTime);
  }

  void updateAlertValue() {
    DatabaseReference dbRef = FirebaseDatabase.instance.reference();

    // Path to the node where "Alert" field is located
    String pathToAlertField = 'Alert';

    // Update the value of the "Alert" field to 1
    dbRef.child(pathToAlertField).set("1").then((_) {
      print('Alert value updated successfully.');
    }).catchError((error) {
      print('Failed to update alert value: $error');
    });
  }

  void _callEmergencyNumber(String phone) async {
    String number = 'tel:$phone';
    if (await canLaunch(number)) {
      await launch(number);
    } else {
      throw 'Could not launch $number';
    }
  }

  Future<String?> _getDestinationAddress(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks.first;
      return "${place.street}, ${place.locality}, ${place.country}";
    } catch (e) {
      return "--------------";
    }
  }
}

Future sendPushMessage(receiver, String receiverToken) async {
  final String serverToken =
      "AAAAPQ5D324:APA91bE1ADCNQD9uRyLZl5G7qLWPXo8NhUeOSL279wXCv-o616wZE7KPFifoRDIOLh3FidgNlJEdq0Z8hWGHN9j0y5-zQ8BJVwsaUPTJPkX96xWIs_pQ2tBqjkLfVmqkKancb3bzY9ez";

  try {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': "New Emergency",
            'title': "Alert"
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': "Alert",
            'receiver': receiver
          },
          "to": receiverToken,
        },
      ),
    );
  } catch (e) {
    print("error push notification");
  }
}

// Future<String?> _getDestinationAddress() async {
//   try {
//     List<Placemark> placemarks = await placemarkFromCoordinates(
//         destination.latitude, destination.longitude);
//     Placemark place = placemarks.first;
//     return "${place.street}, ${place.locality}, ${place.country}";
//   } catch (e) {
//     return "--------------";
//   }
// }

// Set<Polyline> _buildPolylines() {
//   Set<Polyline> polylines = {};
//   if (currentPosition != null && hospitals.isNotEmpty) {
//     var nearestHospital = _findNearestHospital();
//     if (nearestHospital != null) {
//       var data = nearestHospital.data() as Map<String, dynamic>?; // Explicit cast to Map<String, dynamic>
//       if (data != null) {
//         var nearestLatitude = data['latitude'];
//         var nearestLongitude = data['longitude'];
//         if (nearestLatitude != null && nearestLongitude != null) {
//           Polyline polyline = Polyline(
//             polylineId: PolylineId('NearestHospital'),
//             color: Colors.red,
//             width: 3,
//             points: [
//               LatLng(currentPosition!.latitude, currentPosition!.longitude),
//               LatLng(nearestLatitude, nearestLongitude),
//             ],
//           );
//           polylines.add(polyline);
//         }
//       }
//     }
//   }
//   return polylines;
// }

// DocumentSnapshot? _findNearestHospital() {
//   double minDistance = double.infinity;
//   DocumentSnapshot? nearestHospital;
//   for (var hospital in hospitals) {
//     var data = hospital.data() as Map<String, dynamic>?; // Explicit cast to Map<String, dynamic>
//     if (data != null) {
//       var lat = data['latitude'];
//       var lng = data['longitude'];
//       if (lat != null && lng != null) {
//         double distance = Geolocator.distanceBetween(
//             currentPosition!.latitude, currentPosition!.longitude, lat, lng);
//         if (distance < minDistance) {
//           minDistance = distance;
//           nearestHospital = hospital;
//         }
//       }
//     }
//   }
//   return nearestHospital;
// }
