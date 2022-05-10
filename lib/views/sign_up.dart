import 'package:find_my_pet_sg/services/auth.dart';
import 'package:find_my_pet_sg/widgets/widget.dart';
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  bool isLoading = false;
  AuthMethods authMethods = AuthMethods();
  String ? Function(String ?) usernameValidator = (val) {
    return val!.isEmpty || val.length < 4
              ? "Please provide a valid username"
              : null;
  };

  String ? Function(String ?) emailValidator = (val) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!)
              ? null
              : "Please provide a valid email";
  };

  String ? Function(String ?) passwordValidator = (val) {
    return val!.length < 6
              ? "Please provide a password that is 6 characters or greater"
              : null;
  };

  signUp() {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      authMethods.signUpWithEmailAndPassword(emailTextEditingController.text,
          passwordTextEditingController.text).then((val) {
            print("$val.uid");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(context),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 50,
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                    inputTextField("username", userNameTextEditingController, context, usernameValidator),
                      //SizedBox(
                        //height: 10,
                      //),
                      inputTextField("email", emailTextEditingController, context, emailValidator),
                      SizedBox(
                        height: 10,
                      ),
                      inputTextField("password", passwordTextEditingController, context, passwordValidator),
                      SizedBox(
                        height: 8,
                      ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        "Forgot Password?",
                        style: simpleGreyTextStyle(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      signUp();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          const Color(0xff007EF4),
                          const Color(0xff2A75BC),
                        ]),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "Sign up with Google",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 16,),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account? ", style: mediumTextStyle()),
                        Text("Sign in",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ]
                  ),
                  SizedBox(height: 50,)
                ],
              ),
            ),
          ),
        ));
  }
}