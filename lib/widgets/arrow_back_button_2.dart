import 'package:flutter/material.dart';

class ArrowBackButton2 extends StatefulWidget {
  const ArrowBackButton2({Key? key}) : super(key: key);
  @override
  State<ArrowBackButton2> createState() => _ArrowBackButton2State();
}

class _ArrowBackButton2State extends State<ArrowBackButton2> {
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
            color: isTappedDown ? Colors.pink : Colors.white,
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
        // IconButton(
        //   color: Colors.transparent,
        //   icon: Icon(
        //     Icons.arrow_back_rounded,
        //     color: iconColor,
        //     size: 30,
        //   ),
        //   focusColor: Colors.pink,
        //   onPressed: () {
        //     ionColor = Colors.pink;
        //     Navigator.pop(context);
        //   },
        // )
      ],
    );
  }
}
