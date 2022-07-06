import 'package:flutter/material.dart';

class ArrowBackButton3 extends StatefulWidget {
  const ArrowBackButton3({Key? key}) : super(key: key);
  @override
  State<ArrowBackButton3> createState() => _ArrowBackButton3State();
}

class _ArrowBackButton3State extends State<ArrowBackButton3> {
  bool isTappedDown = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkResponse(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: isTappedDown ? Colors.pinkAccent : Colors.pink,
            size: 30,
          ),
          onTapCancel: () {
            setState(() {
              isTappedDown = false;
            });
          },
          onTapDown: (_) {
            setState(() {
              isTappedDown = true;
            });
          },
          onTap: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
