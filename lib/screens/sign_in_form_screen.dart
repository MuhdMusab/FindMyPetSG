import 'package:cloud_firestore/cloud_firestore.dart';
import '../helper/authenticate.dart';
import '../helper/homehelper.dart';
import 'package:find_my_pet_sg/services/database.dart';
import 'package:find_my_pet_sg/screens/home.dart';
import 'package:find_my_pet_sg/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:find_my_pet_sg/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:find_my_pet_sg/screens/verify_email_screen.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  State<SignInForm> createState() => _SignInFormState();
}

final formKey = GlobalKey<FormState>();

class _SignInFormState extends State<SignInForm> {
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  AuthMethods authMethods = AuthMethods();
  bool isLoading = true;
  bool _obscureText = true;
  DatabaseMethods databaseMethods = DatabaseMethods();
  String? Function(String?) usernameValidator = (val) {
    return val!.isEmpty || val.length < 4
        ? "Please provide a valid username"
        : null;
  };

  String? Function(String?) emailValidator = (val) {
    return RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(val!)
        ? null
        : "Please provide a valid email";
  };

  String? Function(String?) passwordValidator = (val) {
    return val!.length < 6
        ? "Please provide a password that is 6 characters or greater"
        : null;
  };

signIn() async {
  if (formKey.currentState!.validate()) {
    setState(() {
      isLoading = true;
    });
    await authMethods
        .signInWithEmailAndPassword(
        emailEditingController.text, passwordEditingController.text)
        .then((result) async {
      if (result != null) {
        if (!(FirebaseAuth.instance.currentUser!.emailVerified)) {
         Navigator.pushReplacement(context, MaterialPageRoute(
           builder: (context) => const VerifyEmailPage(
           ),
         ));
        } else {
          QuerySnapshot userInfoSnapshot =
          await DatabaseMethods().getUserInfo(emailEditingController.text);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                      create: (context) => HomeProvider(),
                      child: Home(userInfoSnapshot.docs[0]))));
        }
      } else {
        setState(() {
          final text = 'Email or Password is invalid';
          final snackBar = SnackBar(
            duration: const Duration(seconds: 60),
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
          isLoading = false;
        });
      }
    });
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
              image: const AssetImage("assets/images/formbackground.png"),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 150, horizontal: 50),
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                child: const Text(
                  "SIGN IN",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 5,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Email",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      validator: emailValidator,
                      controller: emailEditingController,
                      style: simpleBlackTextStyle(),
                      decoration: InputDecoration(
                        fillColor: Colors.grey.withOpacity(0.1),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 15,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "email",
                        hintStyle: const TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Password",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      obscureText: _obscureText,
                      validator: passwordValidator,
                      controller: passwordEditingController,
                      style: simpleBlackTextStyle(),
                      decoration: InputDecoration(
                        fillColor: Colors.grey.withOpacity(0.1),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 15,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "password",
                        hintStyle: const TextStyle(
                          color: Colors.black54,
                        ),
                        suffixIcon: GestureDetector(
                          child: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        signIn();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width - 50,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [
                            Color(0xfff26579),
                            Color(0xfff26579),
                          ]),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Sign in",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontFamily: "Open Sans Extra Bold",
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text("Don't have an account? ",
                          style: mediumTextStyle()),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Authenticate(showSignIn: false,),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                              color: const Color(0xfff26579),
                              fontSize: 17,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                              decorationThickness: 2,
                            ),
                          ),
                        ),
                      ),
                    ]),
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
