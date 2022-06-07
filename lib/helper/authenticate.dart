import 'package:find_my_pet_sg/views/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:find_my_pet_sg/views/sign_in.dart';

class Authenticate extends StatefulWidget {
  bool? showSignIn;
  Authenticate({
    Key? key,
    this.showSignIn,
  }) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {



  void toggleView() {
    setState(() {
      widget.showSignIn = !widget.showSignIn!;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (widget.showSignIn!) {
      return SignIn(toggleView);
    } else {
      return SignUp(toggleView);
    }
  }
}
