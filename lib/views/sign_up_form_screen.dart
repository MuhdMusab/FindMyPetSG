import 'package:find_my_pet_sg/widgets/widget.dart';
import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Column(
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
          ],
          ),
        ),
      ),
    );
  }
}
