import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masari_salik_app/style/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../controller/addAdmin_controller.dart';
import '../../style/fonts.dart';

class ListAdminsScreen extends GetView<AddAdminController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admins", style: robotoMediumBold),
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColor.primary),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'admin')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Display loading indicator while data is being fetched
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot document = documents[index];
              // You can now use 'document' to access the data of each admin
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 4.0,
                  color: AppColor.primarySoft,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.account_circle,
                      size: 32,
                      color: AppColor.primary,
                    ),
                    title: Text(
                      document['name'],
                      style: robotodarkHuge,
                    ), // Assuming 'name' is a field in your user document
                    subtitle: Text(
                      document['email'],
                      style: robotodarkHuge,
                    ), // Assuming 'email' is a field in your user document
                    trailing: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        )),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
