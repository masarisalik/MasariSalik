import 'package:get/get.dart';
import 'package:masari_salik_app/controller/addClinic_controller.dart';
import 'package:masari_salik_app/controller/addHospital_controller.dart';
import 'package:masari_salik_app/controller/chooseStatusController.dart';
import 'package:masari_salik_app/controller/editProfile_controller.dart';
import 'package:masari_salik_app/controller/hosptial_controller.dart';
import 'package:masari_salik_app/controller/listHospital_controller.dart';
import 'package:masari_salik_app/controller/lsitClinic_controller.dart';
import 'package:masari_salik_app/controller/nearestHospital_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/AnotherPatientInfo_controller.dart';
import '../controller/addAdmin_controller.dart';
import '../controller/forgetPassword_controller.dart';
import '../controller/home_controller.dart';
import '../controller/login_controller.dart';
import '../controller/mapPage_controller.dart';
import '../controller/signUp_controller.dart';

Future init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences, fenix: true);
  Get.lazyPut(() => LoginController(sharedPreferences: Get.find()),
      fenix: true);
  Get.lazyPut(() => EditProfileController(), fenix: true);
  Get.lazyPut(() => AnotherPatientInfoController(), fenix: true);
  Get.lazyPut(() => ForgetPasswordController(), fenix: true);

  Get.lazyPut(() => SignUpController(), fenix: true);
  Get.lazyPut(() => HomeController(), fenix: true);
  Get.lazyPut(() => AddAdminController(), fenix: true);
  Get.lazyPut(() => AddHosptalController(), fenix: true);
  Get.lazyPut(() => MapPageController(), fenix: true);
  Get.lazyPut(() => ChooseStatusController(), fenix: true);
  Get.lazyPut(() => HospitalController(), fenix: true);
    Get.lazyPut(() => AddClinicController(), fenix: true);
        Get.lazyPut(() => ListClinicController(), fenix: true);
        Get.lazyPut(() => ListHospitalController(), fenix: true);
        Get.lazyPut(() => NearestHospitalController(), fenix: true);


}
