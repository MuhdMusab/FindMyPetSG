import 'package:find_my_pet_sg/screens/home.dart';
import 'package:find_my_pet_sg/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_pet_sg/services/database.dart';
import 'package:find_my_pet_sg/screens/mainpage.dart';

//QuerySnapshot userInfoSnapshot =
//await DatabaseMethods().getUserInfo(emailTextEditingController.text);

class VerifyEmailPage extends StatefulWidget {
  final username;
  final email;
  const VerifyEmailPage({
    this.username,
    this.email,
  });

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool _isEmailVerified = false;
  bool _canResendEmail = false;
  Timer? timer;



  @override
  void initState() {
    super.initState();
    _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    print(FirebaseAuth.instance.currentUser!.email);
    if (!_isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
          Duration(seconds: 3),
              (timer) => _checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future _checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (_isEmailVerified) {
      timer?.cancel();
    }
  }
  Future sendVerificationEmail() async {
    try {
      print(FirebaseAuth.instance.currentUser!.email);
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() => _canResendEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => _canResendEmail = true);
    } catch (e) {
      final snackbar = SnackBar(
        content: Text(e.toString()),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future moveToHome() async {
    QuerySnapshot querySnapshot= await DatabaseMethods().getUserInfo(FirebaseAuth.instance.currentUser!.email!);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => Home(querySnapshot.docs[0])
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    if (_isEmailVerified) {
      dispose();
      moveToHome();
    }
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Column(
            children: [
              SizedBox(height: 120,),
              Center(
                  child: Icon(
                      Icons.check_box,
                      size: 100,
                      color: Colors.green)
              ),
              SizedBox(height: 10,),
              Text(
                'Check your email',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 25,
                ),
              ),
              SizedBox(height: 10,),
              Text(
                'We have sent you a link in your email to confirm your account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ElevatedButton.icon(
                  onPressed: () => _canResendEmail ? sendVerificationEmail: null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                    primary: Color(0xfff26579),
                  ),
                  icon: Icon(
                    Icons.email,
                    size: 32,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Resend Email',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextButton(
                  onPressed: () => {
                    FirebaseAuth.instance.signOut(),
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainPage(),
                      ),
                    ),
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 24, color: const Color(0xfff26579),),
                  ),
                ),
              ),
            ]
        ),
      ),
    );
  }
}
