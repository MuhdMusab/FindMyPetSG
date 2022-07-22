import 'package:find_my_pet_sg/screens/home.dart';
import 'package:find_my_pet_sg/config/constants.dart';
import 'package:find_my_pet_sg/utils/showSnackBar.dart';
import 'package:find_my_pet_sg/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_pet_sg/services/database.dart';
import 'package:find_my_pet_sg/screens/main_page.dart';

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
    if (!_isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
          const Duration(seconds: 3), (timer) => _checkEmailVerified());
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
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() => _canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => _canResendEmail = true);
    } catch (e) {
      final snackbar = SnackBar(
        content: Text(e.toString()),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future moveToHome() async {
    QuerySnapshot querySnapshot = await DatabaseMethods()
        .getUserInfo(FirebaseAuth.instance.currentUser!.email!);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => Home(querySnapshot.docs[0]),
          fullscreenDialog: true),
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
        child: Column(children: [
          const SizedBox(
            height: 120,
          ),
          const Center(
              child: Icon(Icons.check_box, size: 100, color: Colors.green)),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Check your email',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 25,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'We have sent you a link in your email to confirm your account',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: ElevatedButton.icon(
              onPressed: () {
                if (_canResendEmail) {
                  sendVerificationEmail;
                  showSnackBar(context, "Verification email sent!");
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                primary: pink(),
              ),
              icon: const Icon(
                Icons.email,
                size: 32,
                color: Colors.white,
              ),
              label: const Text(
                'Resend Email',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextButton(
              onPressed: () => {
                FirebaseAuth.instance.signOut(),
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainPage(),
                  ),
                ),
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 24,
                  color: pink(),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
