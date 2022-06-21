import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  final String labelText;
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  const CustomTextfield(
      {Key? key,
      required this.labelText,
      required this.textEditingController,
      required this.textInputType})
      : super(key: key);

  @override
  State<CustomTextfield> createState() => _CustomTextfield();
}

class _CustomTextfield extends State<CustomTextfield> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.textEditingController,
      keyboardType: widget.textInputType,
      decoration: InputDecoration(
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.pink)),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.pink),
        ),
        labelText: widget.labelText,
      ),
    );
  }
}
