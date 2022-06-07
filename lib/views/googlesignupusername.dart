import 'package:find_my_pet_sg/services/database.dart';
import 'package:find_my_pet_sg/views/home.dart';
import 'package:find_my_pet_sg/views/mainpage.dart';
import 'package:find_my_pet_sg/views/sign_up_form_screen.dart';
import 'package:find_my_pet_sg/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GoogleSignUpUsername extends StatefulWidget {
  const GoogleSignUpUsername({Key? key}) : super(key: key);

  @override
  State<GoogleSignUpUsername> createState() => _GoogleSignUpUsernameState();
}

final googleFormKey = GlobalKey<FormState>();

class _GoogleSignUpUsernameState extends State<GoogleSignUpUsername> {
  TextEditingController userNameTextEditingController = TextEditingController();

  String? Function(String?) usernameValidator = (val) {
    return val!.isEmpty || val.length < 4
        ? "Please provide a valid username"
        : null;
  };

  signUp() async {
    if (googleFormKey.currentState!.validate()) {
      if (await DatabaseMethods.containsUsername(
          userNameTextEditingController.text)) {
        setState(() {
          final text = 'Username is taken';
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
        String email = FirebaseAuth.instance.currentUser!.email!;
        Map<String, String> userInfoMap = {
          "name": userNameTextEditingController.text.trim(),
          "email": email,
        };
        DatabaseMethods.addUserInfo(userInfoMap);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(
            ),
          ),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 170,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Enter username",
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
                key: googleFormKey,
                child: TextFormField(
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
                    hintText: "Username",
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
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
