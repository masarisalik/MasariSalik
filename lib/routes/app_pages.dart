import 'package:get/get.dart';
import 'package:masari_salik_app/view/admin/addClinic_screen.dart';
import 'package:masari_salik_app/view/admin/listClinic_screen.dart';
import 'package:masari_salik_app/view/user/chat_screen.dart';
import 'package:masari_salik_app/view/auth/forgetPassword_screen.dart';
import 'package:masari_salik_app/view/hospital_clinic/HospitalHome_screen.dart';
import 'package:masari_salik_app/view/hospital_clinic/chatList_screen.dart';
import 'package:masari_salik_app/view/hospital_clinic/requests_screen.dart';

import '../view/admin/addAdmin_screen.dart';
import '../view/admin/addHospital_screen.dart';
import '../view/admin/adminHome_screen.dart';
import '../view/admin/editAdminProfie_screen.dart';
import '../view/admin/listAdmins_screen.dart';
import '../view/admin/listHospitals_screen.dart';
import '../view/user/anotherPatientInfo_screen.dart';
import '../view/user/chooseStatus_screen.dart';
import '../view/user/editProfie_screen.dart';
import '../view/user/home_screen.dart';
import '../view/user/chooseStatusForPatient_screen.dart';
import '../view/user/startEmergency_screen.dart';
import '../view/auth/login_screen.dart';
import '../view/user/nearestHospital_screen.dart';
import '../view/user/patientInformation_screen.dart';
import '../view/auth/signUp_screen.dart';
import '../view/auth/splash_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: _Paths.SPLASHSCREEN,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: _Paths.SIGNUPSCREEN,
      page: () => SignUpScreen(),
    ),
    GetPage(
      name: _Paths.HOMESCREEN,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: _Paths.PATIENTINFOSCREEN,
      page: () => PatientInformationScreen(),
    ),
    GetPage(
      name: _Paths.CHOOSESTATUS,
      page: () => ChooseStatusScreen(),
    ),
    // GetPage(
    //   name: _Paths.CHATSCREEN,
    //   page: () => ChatScreen(),
    // ),
    GetPage(
      name: _Paths.NEARESTHOSPITALSCREEN,
      page: () => NearestHospitalScreen(),
    ),
    GetPage(
      name: _Paths.EDITPROFILESCREEN,
      page: () => EditProfileScreen(),
    ),
    GetPage(
      name: _Paths.ANOTHERPATIENTINFOSCREEN,
      page: () => AnotherPatientInfoScreen(),
    ),
    // GetPage(
    //   name: _Paths.CHOOSEACCOUNTSCREEN,
    //   page: () => ChooseAccountScreen(),
    // ),
    // GetPage(
    //   name: _Paths.LOGINADMINSCREEN,
    //   page: () => LoginAdminScreen(),
    // ),
    // GetPage(
    //   name: _Paths.LOGINHOSPITALSCREEN,
    //   page: () => LoginHospitalScreen(),
    // ),
    GetPage(
      name: _Paths.ADMINHOMESCREEN,
      page: () => AdminHomeScreen(),
    ),
    GetPage(
      name: _Paths.ADDADMINSCREEN,
      page: () => AddAdminScreen(),
    ),
    GetPage(
      name: _Paths.LISTADMINSSCREEN,
      page: () => ListAdminsScreen(),
    ),
    GetPage(
      name: _Paths.ADDHOSPITALSCREEN,
      page: () => AddHospitalScreen(),
    ),
    GetPage(
      name: _Paths.LISTHOSPITALSSCREEN,
      page: () => ListHospitalsScreen(),
    ),
    GetPage(
      name: _Paths.HOSPITALHOMESCREEN,
      page: () => HospitalHomeScreen(),
    ),
    GetPage(
      name: _Paths.EDITADMINPROFILESCREEN,
      page: () => EditAdminProfileScreen(),
    ),
    GetPage(
      name: _Paths.STARTEMERGENCYSCREEN,
      page: () => StartEmergencyScreen(),
    ),
    GetPage(
      name: _Paths.FORGETPASSWORD,
      page: () => ForgetPasswordScreen(),
    ),
    GetPage(
      name: _Paths.CHOOSESTATUSFORPATIENT,
      page: () => ChooseStatusForPatientScreen(),
    ),
    // GetPage(
    //   name: _Paths.MAPPAGESCREEN,
    //   page: () => MapPageScreen(),
    // ),
       GetPage(
      name: _Paths.REQUESTSSCREEN,
      page: () => RequestsScreen(),
    ),
      GetPage(
      name: _Paths.CHATLISTSCREEN,
      page: () => ChatListScreen(),
    ),
     GetPage(
      name: _Paths.ADDCLINICSCREEN,
      page: () => AddClinicScreen(),
    ),
      GetPage(
      name: _Paths.LISTCLINCSSCREEN,
      page: () => ListClinicScreen(),
    ),
  ];
}
