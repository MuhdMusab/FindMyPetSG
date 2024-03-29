import '../helper/google_sign_in_provider.dart';
import 'package:find_my_pet_sg/config/constants.dart';
import 'package:find_my_pet_sg/services/database.dart';
import 'package:find_my_pet_sg/screens/forgot_password_screen.dart';
import 'package:find_my_pet_sg/screens/google_signup_username.dart';
import 'package:find_my_pet_sg/screens/main_page.dart';
import 'package:find_my_pet_sg/screens/sign_up_form_screen.dart';
import 'package:find_my_pet_sg/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  const SignUp(this.toggle, {Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  hasUsername() async {
    if (await DatabaseMethods.containsEmail(FirebaseAuth.instance.currentUser!.email!)) {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => const MainPage(),
      ));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => const GoogleSignUpUsername(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(context),
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/signinpage.png"
                ),
                fit: BoxFit.cover,
              ),
            ),
            height: MediaQuery.of(context).size.height - 50,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ForgotPassword(),
                  )),
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: const Text(
                        "Forgot Password?",
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => const SignUpForm()
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),
                    primary: pink(),
                    fixedSize: Size(MediaQuery.of(context).size.width - 50, 66),
                  ),
                  child: const Text(
                    "Sign up",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontFamily: "Open Sans Extra Bold",
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton.icon(
                  icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red,),
                  onPressed: () {
                    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                    provider.googleLogin();
                    hasUsername();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),
                    primary: Colors.white,
                    fixedSize: Size(MediaQuery.of(context).size.width - 50, 66),
                  ),
                  label: const Text(
                    "Sign up with Google",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 19,
                        fontFamily: "Open Sans Extra Bold",
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                const SizedBox(height: 16,),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? ", style: mediumTextStyle()),
                      GestureDetector(
                        onTap: () {
                          widget.toggle();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text("Sign in",
                            style: TextStyle(
                              color: pink(),
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
                const SizedBox(height: 50,)
              ],
            ),
          ),
        ));
  }
}