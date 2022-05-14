import 'package:find_my_pet_sg/views/explore_screen.dart';
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
  bool _passwordVisible = false;

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
            builder: (context) => ExploreScreen(),
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
                  TextFormField(
                    validator: usernameValidator,
                    controller: userNameTextEditingController,
                    style: simpleBlackTextStyle(),
                    decoration: InputDecoration(
                      fillColor: Colors.grey.withOpacity(0.1),
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 15,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white,
                          width: 0,),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white,
                          width: 0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white,
                          width: 0,),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: "username",
                      hintStyle: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ),
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
                  TextFormField(
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
                        borderSide: BorderSide(color: Colors.white,
                          width: 0,),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white,
                          width: 0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white,
                          width: 0,),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: "email",
                      hintStyle: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ),
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
                TextFormField(
                  obscureText: _passwordVisible,
                  validator: passwordValidator,
                  controller: passwordTextEditingController,
                  style: simpleBlackTextStyle(),
                  decoration: InputDecoration(
                      fillColor: Colors.grey.withOpacity(0.1),
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 15,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white,
                          width: 0,),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white,
                          width: 0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white,
                          width: 0,),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: "password",
                      hintStyle: TextStyle(
                           color: Colors.black54,
                         ),
                      suffixIcon: GestureDetector(
                        child: Icon(
                          _passwordVisible ? Icons.visibility
                                           : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onTap: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                  ),

                ),
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
