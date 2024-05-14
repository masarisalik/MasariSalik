import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:masari_salik_app/view/user/complains.dart';
import 'package:permission_handler/permission_handler.dart';

class ChooseStatusController extends GetxController {
  late Rx<LatLng> origin = LatLng(0, 0).obs;
  late List<Complaint> complaints;

  @override
  void onInit() {
    // checkLocationPermission();
    complaints = [
    Complaint('fever', 'simple'),
    Complaint('SOB', 'complicated'),
    Complaint('headache', 'complicated'),
   
    Complaint('4 month pregnant', 'complicated'),
    Complaint('5 month pregnant', 'complicated'),
    Complaint('2 month pregnant with vomiting', 'complicated'),
    Complaint('SOB', 'complicated'),
    Complaint('fever , vomiting', 'complicated'),
    Complaint('epigastric pain', 'complicated'),
    Complaint('RT hand pain', 'complicated'),
    Complaint('fall down', 'complicated'),
    Complaint('LT foot pain', 'complicated'),
    Complaint('LT leg trauma', 'complicated'),
    Complaint('RT hand trauma', 'complicated'),
    Complaint('RT flank pain', 'complicated'),
    Complaint('LT flank pain', 'complicated'),
    Complaint('abdominal pain', 'complicated'),
    Complaint('abdominal pain , menstrual pain', 'complicated'),
    Complaint('1 month pregnant bleeding', 'complicated'),
    Complaint('fever , 5 month pregnant', 'complicated'),
    Complaint('vomiting', 'complicated'),
    Complaint('SOB , cough', 'complicated'),
    Complaint('fever, sore throat', 'complicated'),
    Complaint('SOB , vomiting', 'complicated'),
    Complaint('cough', 'complicated'),
    Complaint('cough, sore throat', 'complicated'),
    Complaint('polytrauma', 'complicated'),
    Complaint('SCD , pain crisis', 'complicated'),
    Complaint('epigastric pain', 'complicated'),
    Complaint('dizziness , palpitations', 'complicated'),
    Complaint('abdominal distension , nausea', 'complicated'),
    Complaint('abdominal pain', 'complicated'),
    Complaint('cough', 'complicated'),
    Complaint('fever , cough', 'complicated'),
    Complaint('SOB', 'complicated'),
    Complaint('fever , body pain', 'complicated'),
    Complaint('headache , left hand weakness', 'complicated'),
    Complaint('abdominal pain', 'complicated'),
    Complaint('body weakness', 'complicated'),
    Complaint('left flank pain', 'complicated'),
    Complaint('Ear pain', 'complicated'),
    Complaint('back pain', 'complicated'),
    Complaint('right foot trauma', 'complicated'),
    Complaint('4 month pregnant , headache and abdominal pain', 'complicated'),
    Complaint('5 month pregnant , no fetal movement', 'complicated'),
    Complaint('9 month pregnant , labor pain', 'complicated'),
    Complaint('assault , left hand pain', 'complicated'),
    Complaint('urine micronation , burning sensation dysuria', 'complicated'),
    Complaint('scrotal injury', 'complicated'),
    Complaint('abdominal pain', 'complicated'),
    Complaint('left side chest pain', 'complicated'),
    Complaint('right lower abdominal pain', 'complicated'),
    Complaint('abdominal pain', 'complicated'),
    Complaint('fall down right hand trauma', 'complicated'),
    Complaint('fever cough SOB', 'complicated'),
    Complaint('fever', 'complicated'),
    Complaint('fever', 'complicated'),
    Complaint('vomiting', 'complicated'),
    Complaint('fever runny nose', 'complicated'),
    Complaint('fever', 'complicated'),
    Complaint('palpitations headache , epigastric pain', 'complicated'),
    Complaint('abdominal pain LLQ headache', 'complicated'),
    Complaint('high blood pressure', 'complicated'),
    Complaint('vomiting , fever , cough', 'complicated'),
    Complaint('SOB , HTN type 2 respiratory failure', 'complicated'),
    Complaint('LT wound on LT pain', 'complicated'),
    Complaint('RT big the wound', 'complicated'),
    Complaint('RT finger trauma', 'complicated'),
    Complaint('fall down', 'complicated'),
    Complaint('swelling on RT toe', 'complicated'),
    Complaint('sob', 'complicated'),
    Complaint('cough runny nose', 'complicated'),
    Complaint('constipation for 7 days', 'complicated'),
    Complaint('fever', 'complicated'),
    Complaint('eye irritation', 'complicated'),
    Complaint('uterine fibroid', 'complicated'),
    Complaint('ACS , STEMI', 'complicated'),
    Complaint('g2 p1 32 weeks with bleeding', 'complicated'),
    Complaint('vomiting , diarrhea', 'complicated'),
    Complaint('bilateral leg pain', 'complicated'),
    Complaint('chest pain', 'complicated'),
    Complaint('sickle cell anemia', 'complicated'),
    Complaint('7 month pregnant with sob', 'complicated'),
    Complaint('vaginal bleeding', 'complicated'),
    Complaint('asthma treatment', 'complicated'),

    Complaint('sinusitis', 'simple'),
    Complaint('flu', 'simple'),
    Complaint('ear pain', 'simple'),
    Complaint('sprains', 'simple'),
    Complaint('bruises', 'simple'),
    Complaint('eye irritations', 'simple'),
    Complaint('Minor Burns', 'simple'),
    Complaint('Musculoskeletal', 'simple'),
    Complaint('mild hives', 'simple'),
    Complaint('swelling', 'simple'),
    Complaint('Routine vaccinations for c and a', 'simple'),
    Complaint('mild dizziness', 'simple'),
    Complaint('Minor dental issues', 'simple'),
    Complaint('premenstrual syndrome (PMS)', 'simple'),
    ];
    super.onInit();
  }

  Future<void> checkLocationPermission() async {
    // Check if location permission is granted
    final PermissionStatus permissionStatus =
        await Permission.locationWhenInUse.status;

    if (permissionStatus.isGranted) {
      // If permission is granted, get current location
      getCurrentLocation();
    } else {
      // If permission is not granted, request permission
      final PermissionStatus requestedPermissionStatus =
          await Permission.locationWhenInUse.request();
      if (requestedPermissionStatus.isGranted) {
        // If permission is granted after request, get current location
        getCurrentLocation();
      } else {
        // If permission is still not granted, show a message to the user
        print("Location permission is not granted.");
      }
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      geo.Position position = await geo.Geolocator.getCurrentPosition(
          desiredAccuracy: geo.LocationAccuracy.high);
      origin.value = LatLng(
          position.latitude, position.longitude); // Update origin's value
    } catch (e) {
      print('Could not get the location: $e');
    }
  }
}
