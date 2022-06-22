import 'package:flutter/material.dart';

class ArrowBackButton extends StatefulWidget {
  const ArrowBackButton({Key? key}) : super(key: key);
  @override
  State<ArrowBackButton> createState() => _ArrowBackButtonState();
}

class _ArrowBackButtonState extends State<ArrowBackButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
