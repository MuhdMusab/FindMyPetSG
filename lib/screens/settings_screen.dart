import 'package:find_my_pet_sg/config/constants.dart';
import 'package:find_my_pet_sg/helper/google_sign_in_provider.dart';
import 'package:find_my_pet_sg/screens/main_page.dart';
import 'package:find_my_pet_sg/widgets/edit_notifications_settings_dialog.dart';
import 'package:find_my_pet_sg/widgets/notifications_denied_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: pink(),
        ),
        centerTitle: true,
        title: Text(
          "Settings",
          style: TextStyle(
            fontSize: 20,
            color: pink(),
            fontFamily: 'Open Sans Extra Bold',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () async {
              PermissionStatus permissionStatus = await NotificationPermissions
                  .getNotificationPermissionStatus();
              if (permissionStatus == PermissionStatus.denied) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return NotificationsDeniedDialog();
                    });
              } else if (permissionStatus == PermissionStatus.granted) {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return WillPopScope(
                          onWillPop: () async => false,
                          child: EditNotificationsSettingsDialog());
                    });
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 50,
                child: Row(children: [
                  const Icon(
                    Icons.notifications_none,
                    size: 32,
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ]),
              ),
            ),
          ),
          Container(
            child: const Divider(
              height: 1,
            ),
            padding: const EdgeInsets.only(left: 20),
          ),
          Container(
            child: const Divider(
              height: 1,
            ),
            padding: const EdgeInsets.only(left: 20),
          ),
          Container(
            child: const Divider(
              height: 1,
            ),
            padding: const EdgeInsets.only(left: 20),
          ),
          InkWell(
            onTap: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.logout();
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const MainPage()),
                  (Route<dynamic> route) => false);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 50,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Icon(
                        Icons.logout,
                        size: 32,
                        color: pink(),
                      ),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 17,
                        color: pink(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
