import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:masari_salik_app/routes/app_pages.dart';
import 'package:masari_salik_app/style/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../style/fonts.dart';
import '../../widgets/adminDrawer.dart';

class AdminHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome to Masari Salik",
          style: robotoMediumBold,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.person_2),
            onPressed: () {

Get.toNamed(Routes.EDITPROFILESCREEN);

            },
          )
        ],
        iconTheme: IconThemeData(color: AppColor.primary),
      ),
      drawer: const AdminDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHospitalsRow(),
             _buildClinicsRow(),
            _buildAdminsRow(),
            _buildUsersRow(),
            _buildTodayOperationsRow(),
            _buildTotalOperationsRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildHospitalsRow() {
    return _buildRow("Hospitals", Icons.local_hospital, () async {
      int hospitalCount = await _getDocumentCount("hospital");
      return hospitalCount;
    });
  }
  Widget _buildClinicsRow() {
    return _buildRow("Clinics", Icons.medical_information, () async {
      int hospitalCount = await _getDocumentCount("clinic");
      return hospitalCount;
    });
  }
  Widget _buildAdminsRow() {
    return _buildRow("Admins", Icons.supervised_user_circle_sharp, () async {
      int adminCount = await _getDocumentCount("admin");
      return adminCount;
    });
  }

  Widget _buildUsersRow() {
    return _buildRow("Users", Icons.supervised_user_circle_sharp, () async {
      int userCount = await _getDocumentCount("user");
      return userCount;
    });
  }

  Widget _buildTodayOperationsRow() {
    return _buildRow("Today's Operations", Icons.done_outline_rounded,
        () async {
      int todayOperationsCount = await _getOperationsDailyCount();
      return todayOperationsCount;
    });
  }

  Widget _buildTotalOperationsRow() {
    return _buildRow("Total Operations", Icons.summarize_rounded, () async {
      int totalOperationsCount = await _getTotalOperationsCount();
      return totalOperationsCount;
    });
  }

  Widget _buildRow(
      String title, IconData icon, Future<int> Function() getCountFunction) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: FutureBuilder<int>(
        future: getCountFunction(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Display loading indicator while data is being fetched
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          final int documentCount = snapshot.data ?? 0;
          return Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 4.0,
                  color: AppColor.primarySoft,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListTile(
                      leading: Icon(
                        icon,
                        size: 46,
                        color: AppColor.primary,
                      ),
                      title: Text(
                        title,
                        style: robotoMediumBold,
                      ),
                      subtitle: Text(
                        documentCount.toString(),
                        style: robotoExtraHuge,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<int> _getDocumentCount(String role) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: role)
        .get();
    return snapshot.docs.length;
  }

  String formatDate(DateTime date, String format) {
  final formatter = DateFormat(format);
  return formatter.format(date);
}
Future<int> _getOperationsDailyCount() async {
  // Get the current date and time
  DateTime now = DateTime.now();
  
  // Format the date to "DD MM YYYY"
  String formattedDate = formatDate(now, 'dd MM yyyy');
  
  // Query Firestore
  final QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('operations')
      .where('operationDate', isEqualTo: formattedDate)
      .get();

  // Return the count of documents
  return snapshot.docs.length;
}

  Future<int> _getTotalOperationsCount() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('operations').get();
    return snapshot.docs.length;
  }
}
