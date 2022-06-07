import 'package:find_my_pet_sg/services/database.dart';
import 'package:find_my_pet_sg/views/googlesignupusername.dart';
import 'package:flutter/material.dart';
import 'package:find_my_pet_sg/helper/authenticate.dart';
import 'package:find_my_pet_sg/views/verify_email_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:find_my_pet_sg/views/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_pet_sg/helper/homehelper.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}
// bool _helper() async {
//   return (await DatabaseMethods.containsEmail(
//       FirebaseAuth.instance.currentUser!.email!).whe;
// }


class _MainPageState extends State<MainPage> {
  hasUsername() async {
    if (await DatabaseMethods.containsEmail(FirebaseAuth.instance.currentUser!.email!)) {
      QuerySnapshot querySnapshot= await DatabaseMethods().getUserInfo(FirebaseAuth.instance.currentUser!.email!);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>
              ChangeNotifierProvider(
                  create: (context) => HomeProvider(),
                  child: Home(querySnapshot.docs[0]))
          ));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => GoogleSignUpUsername(),
      ));
    }
  }

  Future move() async {
    bool emailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    QuerySnapshot querySnapshot= await DatabaseMethods().getUserInfo(FirebaseAuth.instance.currentUser!.email!);
    if (emailVerified) {
      hasUsername();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => VerifyEmailPage()
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    bool containsEmail = false;
    QuerySnapshot? querySnapshot;
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            move();
            return Scaffold();
          } else {
            return Authenticate(showSignIn: false,);
          }
        },
      ),
    );
  }
}
