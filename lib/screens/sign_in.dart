import 'package:find_my_pet_sg/services/database.dart';
import 'package:find_my_pet_sg/screens/forgot_password_screen.dart';
import 'package:find_my_pet_sg/screens/googlesignupusername.dart';
import 'package:find_my_pet_sg/screens/sign_in_form_screen.dart';
import 'package:find_my_pet_sg/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:find_my_pet_sg/helper/google_sign_in_provider.dart';
import 'package:find_my_pet_sg/screens/mainpage.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  hasUsername(String email) async {
    //await Future.delayed(Duration(seconds: 1));
    if (await DatabaseMethods.containsEmail(email)) {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => MainPage(),
      ));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => GoogleSignUpUsername(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(context),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/images/signinpage.png"
                ),
                fit: BoxFit.cover,
              ),
            ),
            height: MediaQuery.of(context).size.height - 50,
            alignment: Alignment.bottomCenter,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ForgotPassword(),
                    )),
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => SignInForm()
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),
                      primary: const Color(0xfff26579),
                      fixedSize: Size(MediaQuery.of(context).size.width - 50, 66),
                    ),
                    child: Text(
                      "Sign in",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontFamily: "Open Sans Extra Bold",
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton.icon(
                    icon: FaIcon(FontAwesomeIcons.google, color: Colors.red,),
                    onPressed: () {
                      final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                      provider.googleLogin();
                      hasUsername(provider.getEmail());
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),
                      primary: Colors.white,
                      fixedSize: Size(MediaQuery.of(context).size.width - 50, 66),
                    ),
                    label: Text(
                      "Sign in with Google",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 19,
                          fontFamily: "Open Sans Extra Bold",
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  SizedBox(height: 16,),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? ", style: mediumTextStyle()),
                        GestureDetector(
                          onTap: () {
                            widget.toggle();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text("Sign up",
                              style: TextStyle(
                                color: Color(0xfff26579),
                                fontSize: 17,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                decorationThickness: 2,
                              ),
                            ),
                          ),
                        ),
                      ]
                  ),
                  SizedBox(height: 50,),
                ],
              ),
            ),
          ),
        ));
  }
}