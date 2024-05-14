import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:masari_salik_app/widgets/custom_toast.dart';

class ListClinicController extends GetxController {
  void deleteClinic(String clinicId) {


    FirebaseFirestore.instance
        .collection('users')
        .doc(clinicId) // Use clinic ID to reference the document
        .delete()
        .then((_) {
      CustomToast.successToast('Clinic deleted successfully');
      print('Clinic deleted successfully');
    }).catchError((error) {
      // Handle errors if any
      CustomToast.errorToast(
          'Failed to delete clinic: $error');
      print('Failed to delete clinic: $error');
    });
  }}