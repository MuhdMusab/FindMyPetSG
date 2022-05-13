import 'package:find_my_pet_sg/views/chatRoomScreen.dart';
import 'package:find_my_pet_sg/views/sign_in.dart';
import 'package:find_my_pet_sg/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:find_my_pet_sg/services/auth.dart';

class SignUpForm extends StatefulWidget {

  // final Function toggle;
  // SignUpForm(this.toggle);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  AuthMethods authMethods = AuthMethods();
  bool isLoading = true;

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
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => ChatRoom(),
        ),);
      });
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
                  "assets/images/formbackground.png"
              ),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 150, horizontal: 50),
          alignment: Alignment.center,
          child: Column(
          children: [
            Container(
                child: Text(
                  "SIGN UP",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              alignment: Alignment.centerLeft,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text("Username",
                style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
              inputTextFieldCircular("username", userNameTextEditingController, context, usernameValidator, 5),
              SizedBox(
                height: 13,
              ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Email",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                inputTextFieldCircular("email", emailTextEditingController, context, emailValidator, 5),
                SizedBox(
                  height: 13,
                ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Password",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                inputTextFieldCircular("password", passwordTextEditingController, context, passwordValidator, 5),
                SizedBox(
                  height: 20,
                ),
                  GestureDetector(
                    onTap: () {
                     signUp();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width - 50,
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          const Color(0xfff26579),
                          const Color(0xfff26579),
                        ]),
                        borderRadius: BorderRadius.circular(20),
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
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account? ", style: mediumTextStyle()),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (context) => SignIn(() => null),
                            ),);
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
                ],
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}
