import 'package:find_my_pet_sg/helper/homehelper.dart';
import 'package:find_my_pet_sg/services/database.dart';
import 'package:find_my_pet_sg/screens/google_signup_username.dart';
import 'package:flutter/material.dart';
import 'package:find_my_pet_sg/screens/verify_email_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:find_my_pet_sg/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../helper/authenticate.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  hasUsername() async {
    if (await DatabaseMethods.containsEmail(
        FirebaseAuth.instance.currentUser!.email!)) {
      QuerySnapshot querySnapshot = await DatabaseMethods()
          .getUserInfo(FirebaseAuth.instance.currentUser!.email!);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                  create: (context) => HomeProvider(),
                  child: Home(querySnapshot.docs[0]))));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GoogleSignUpUsername(),
          ));
    }
  }

  Future move() async {
    bool emailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (emailVerified) {
      hasUsername();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => VerifyEmailPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            move();
            return Scaffold();
          } else {
            return Authenticate(
              showSignIn: false,
            );
          }
        },
      ),
    );
  }
}
