import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';

class MapPageController extends GetxController {
  // late final String name;

  // @override
  // void onInit() {
  //   super.onInit();
  //   // Retrieve the name from Get.arguments when the controller is initialized
  //   name = Get.arguments as String? ?? ''; // Ensure to handle null
  //   print("Name: $name"); // Print the name
  // }
  Future<void> operation2(String name) async {
    print("Name: $name");
  }

  void getthem(int me) {}
  Future<void> operation(String name) async {
    print("Name: $name");
    try {
      // Fetch data from Firestore collection "patients" where name matches
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection("patients")
              .where("name", isEqualTo: name)
              .get();

      // Check if there's a document with the provided name
      if (querySnapshot.docs.isNotEmpty) {
        // Extract data from the document
        final Map<String, dynamic> patientData =
            querySnapshot.docs.first.data();
        final String phone = patientData['phone'];
        final String gender = patientData['gender'];
        final String height = patientData['height'];
        final String weight = patientData['weight'];
        final String birthdate = patientData['birthdate'];

        // Insert the extracted data into the "operations" collection
        await FirebaseFirestore.instance.collection("operations").add({
          "name": name,
          "phone": phone,
          "gender": gender,
          "height": height,
          "weight": weight,
          "birthdate": birthdate,
          // Add other fields as needed
        });
        print("Operation saved successfully");
        await Get.toNamed(Routes.STARTEMERGENCYSCREEN);
      } else {
        print("No patient found with name: $name");
        // Handle if no patient found with the provided name
      }
    } catch (e) {
      print("Error performing operation: $e");
      // Handle error as needed
    }
  }
}
