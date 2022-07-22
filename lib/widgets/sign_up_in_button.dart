import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/constants.dart';

class SignUpInButton extends StatefulWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onPressed;
  const SignUpInButton({
    Key? key,
    required this.isLoading,
    required this.text,
    required this.onPressed,
  }) : super(key: key);
  @override
  State<SignUpInButton> createState() => _SignUpInButtonState();
}

class _SignUpInButtonState extends State<SignUpInButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.pink,
        borderRadius: BorderRadius.circular(20),
      ),
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: pink(),
            shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0))),
        onPressed: widget.onPressed,
        child: Center(
          child: widget.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Colors.white,
                ))
              : Text(
                  widget.text,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
        ),
      ),
    );
  }
}
