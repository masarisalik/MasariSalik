import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:masari_salik_app/widgets/custom_toast.dart';

class ListHospitalController extends GetxController {
  void deleteClinic(String hospitalId) {


    FirebaseFirestore.instance
        .collection('users')
        .doc(hospitalId) // Use clinic ID to reference the document
        .delete()
        .then((_) {
      CustomToast.successToast('Hospital deleted successfully');
      print('Hospital deleted successfully');
    }).catchError((error) {
      // Handle errors if any
      CustomToast.errorToast(
          'Failed to delete Hospital: $error');
      print('Failed to delete Hospital: $error');
    });
  }}