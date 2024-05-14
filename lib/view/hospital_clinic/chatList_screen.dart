import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masari_salik_app/controller/hosptial_controller.dart';
import 'package:masari_salik_app/style/app_color.dart';
import 'package:masari_salik_app/view/hospital_clinic/hospitalChat_screen.dart';
import '../../style/fonts.dart';
import '../../widgets/Drawer.dart';
class ChatListScreen extends GetView<HospitalController> {
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
              controller.getWhoChatWithHospital();
            },
          )
        ],
        iconTheme: IconThemeData(color: AppColor.primary),
      ),
      drawer: const MyDrawer(),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: controller.getWhoChatWithHospital(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      // Navigate to chat screen or perform any action
                    },
                    child: Card(
                      elevation: 4.0,
                      color: AppColor.primarySoft,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HospitalChatScreen(
                                recipientUserId: user['userId'],
                                recipientEmail: user['email'],
                                recipientToken: user['userToken'],
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            // You can set the profile picture here
                            backgroundColor: AppColor.primary,
                            child: Text(
                              user['name'][0],
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            user['name'],
                            style: robotoMediumBold,
                          ),
                          subtitle: Text(
                            user['email'],
                            style: robotoRegular,
                          ),
                          trailing: Icon(
                            Icons.chat,
                            color: AppColor.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
