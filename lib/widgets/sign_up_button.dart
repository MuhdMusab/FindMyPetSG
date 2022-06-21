import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/*Button for sign in and sign up */

class CustomMadeButton extends StatefulWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onPressed;
  const CustomMadeButton({
    Key? key,
    required this.isLoading,
    required this.text,
    required this.onPressed,
  }) : super(key: key);
  @override
  State<CustomMadeButton> createState() => _CustomMadeButtonState();
}

class _CustomMadeButtonState extends State<CustomMadeButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.pink,
        borderRadius: BorderRadius.circular(12),
      ),
      height: 50,
      width: 370,
      child: ElevatedButton(
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
// onPressed: () {
//   Navigator.pushNamedAndRemoveUntil(
//       context, widget.routeName, (route) => false);
//   // Navigator.pushReplacementNamed(context, widget.routeName);
// },
