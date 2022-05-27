import 'package:find_my_pet_sg/views/sign_up_form_screen.dart';
import 'package:find_my_pet_sg/widgets/widget.dart';
import "package:flutter/material.dart";

class SignUp extends StatefulWidget {
  //const SignUp({Key? key}) : super(key: key);

  final Function toggle;
  SignUp(this.toggle);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

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
                  Container(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => SignUpForm()
                      ));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width - 50,
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          const Color(0xfff26579),
                          const Color(0xfff26579),
                        ]),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontFamily: "Open Sans Extra Bold",
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width - 50,
                    padding: EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "Sign up with Google",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Open Sans Extra Bold",
                      ),
                    ),
                  ),
                  SizedBox(height: 16,),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account? ", style: mediumTextStyle()),
                        GestureDetector(
                          onTap: () {
                            widget.toggle();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text("Sign in",
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
                  SizedBox(height: 50,)
                ],
              ),
            ),
          ),
        ));
  }
}