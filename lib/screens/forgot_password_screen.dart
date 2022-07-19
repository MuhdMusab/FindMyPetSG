import 'package:find_my_pet_sg/config/constants.dart';
import 'package:find_my_pet_sg/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:find_my_pet_sg/widgets/widget.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

final forgotPasswordFormKey = GlobalKey<FormState>();

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailTextEditingController = TextEditingController();

  String? Function(String?) emailValidator = (val) {
    return RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(val!)
        ? null
        : "Please provide a valid email";
  };

  resetPassword() async {
    if (forgotPasswordFormKey.currentState!.validate()) {
      if (!(await DatabaseMethods.containsEmail(
          emailTextEditingController.text))) {
        setState(() {
          final text = 'Email is not in our database';
          final snackBar = SnackBar(
            duration: Duration(seconds: 60),
            content: Text(text),
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.blue,
              onPressed: () {},
            ),
          );
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(snackBar);
        });
      } else {
        await FirebaseAuth.instance.sendPasswordResetEmail(
            email: emailTextEditingController.text.trim()
        );
        setState(() {
          final text = 'Password Reset Email Sent';
          final snackBar = SnackBar(
            duration: Duration(days: 365),
            content: Text(text),
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.blue,
              onPressed: () {},
            ),
          );
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(snackBar);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: pink()),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Reset Password",
          style: TextStyle(
            fontSize: 18,
            color: pink(),
            fontFamily: 'Open Sans Extra Bold',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 170,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Enter your email to reset password",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              alignment: Alignment.centerLeft,
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: forgotPasswordFormKey,
                child: TextFormField(
                  validator: emailValidator,
                  controller: emailTextEditingController,
                  style: simpleBlackTextStyle(),
                  decoration: InputDecoration(
                    fillColor: Colors.grey.withOpacity(0.1),
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 15,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Email",
                    hintStyle: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            ElevatedButton.icon(
              icon: Icon(
                Icons.email,
                size: 32,
                color: Colors.white,
              ),
              onPressed: () {
                resetPassword();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),
                primary: pink(),
                fixedSize: Size(MediaQuery.of(context).size.width - 50, 66),
              ),
              label: Text(
                "Reset Password",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontFamily: "Open Sans Extra Bold",
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
