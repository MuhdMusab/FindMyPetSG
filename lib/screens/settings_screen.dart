import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:find_my_pet_sg/helper/google_sign_in_provider.dart';
import 'package:find_my_pet_sg/services/storage_service.dart';
import 'package:find_my_pet_sg/screens/mainpage.dart';
import 'package:find_my_pet_sg/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        iconTheme: IconThemeData(
          color: Color(0xFFf26579),
        ),
        centerTitle: true,
        title: Text(
          "Settings",
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFFf26579),
            fontFamily: 'Open Sans Extra Bold',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 50,
            child: Row(children:
            [
              Icon(Icons.notifications_none,
                size: 32,
              ),
              SizedBox(width: 3,),
              Text('Notifications',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              Spacer(),
              IconButton(onPressed: () => {},
                  icon: Icon(Icons.navigate_next,
                    size: 30,
                  )
              ),
            ],
            ),
          ),
          Container(child: Divider(),
            padding: EdgeInsets.symmetric(horizontal: 20),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 50,
            child: Row(children:
            [
              Icon(Icons.lock_outline,
                size: 32,
              ),
              SizedBox(width: 3,),
              Text('Privacy & Security',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              Spacer(),
              IconButton(onPressed: () => {},
                  icon: Icon(Icons.navigate_next,
                    size: 30,
                  )
              ),
            ],
            ),
          ),
          Container(child: Divider(),
            padding: EdgeInsets.symmetric(horizontal: 20),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 50,
            child: Row(children:
            [
              FaIcon(FontAwesomeIcons.circleQuestion,
                size: 32,
              ),
              SizedBox(width: 5,),
              Text('About',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              Spacer(),
              IconButton(onPressed: () => {},
                  icon: Icon(Icons.navigate_next,
                    size: 30,
                  )
              ),
            ],
            ),
          ),
          Container(child: Divider(),
            padding: EdgeInsets.symmetric(horizontal: 20),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 50,
            child: Row(children:
            [
              IconButton(
                  onPressed: () {
                    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                    provider.logout();
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(

                        builder: (context) => MainPage(),
                      ),
                    );
                  },
                  padding: EdgeInsets.only(left: 8),
                  icon: Icon(Icons.logout,
                    size: 32,
                    color: Color(0xFFf26579),
                  )
              ),
              SizedBox(width: 0,),
              Text('Logout',
                style: TextStyle(
                  fontSize: 17,
                  color: Color(0xFFf26579),
                ),
              ),
            ],
            ),
          ),
        ],
      ),
    );
  }
}

