import 'package:flutter/material.dart';

class PostTypeButton extends StatefulWidget {
  final int index;
  final String text;
  final Function callback;

  const PostTypeButton({
    Key? key,
    required this.index,
    required this.text,
    required this.callback,
  }) : super(key: key);

  @override
  State<PostTypeButton> createState() => _PostTypeButtonState();
}

class _PostTypeButtonState extends State<PostTypeButton> {
  bool enabled = false;
  @override
  Widget build(BuildContext context) {
    return
      ElevatedButton(
        onPressed: () {
          setState(() {
            enabled = !enabled;
            widget.callback(widget.index);
          });
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          primary: enabled ? Color(0xFFff9dab)
                    : Colors.white,
          fixedSize: Size(150, 50),
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            fontFamily: 'Futura',
            color: Color(0xFF2b2e4a),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      );
  }
}
