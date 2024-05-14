import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masari_salik_app/routes/app_pages.dart';
import 'package:masari_salik_app/style/fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/alertExitApp.dart';
import '../style/app_color.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          final sharedPreferences = snapshot.data;
          final username = sharedPreferences?.getString('name') ?? '';
          final phone = sharedPreferences?.getString('phone') ?? '';

          return ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                currentAccountPictureSize: const Size.square(10.0),
                accountName: Text(
                  username,
                  style: robotoHugeWhite,
                ),
                accountEmail: Text(
                  phone,
                  style: robotoHugeWhite,
                ),
                decoration: BoxDecoration(
                  color: AppColor.primary,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.edit_document),
                title: const Text(
                  'Edit Profile',
                ),
                onTap: () {
                  Get.toNamed(Routes.EDITPROFILESCREEN);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout_outlined),
                title: const Text('Logout'),
                onTap: () {
                  alertExitApp();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
