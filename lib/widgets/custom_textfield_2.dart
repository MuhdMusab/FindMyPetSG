import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextfield2 extends StatefulWidget {
  final String infoText;
  final String hintText;
  final int maxLines;
  final int maxLength;
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final List<TextInputFormatter> inputFormatters;
  CustomTextfield2(
      {Key? key,
      required this.inputFormatters,
      required this.hintText,
      required this.textEditingController,
      required this.textInputType,
      required this.infoText,
      required this.maxLines,
      required this.maxLength})
      : super(key: key);

  @override
  State<CustomTextfield2> createState() => _CustomTextfield2();
}

class _CustomTextfield2 extends State<CustomTextfield2> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 4.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(widget.infoText),
            ],
          ),
          TextField(
            inputFormatters: widget.inputFormatters,
            style: TextStyle(fontSize: 20),
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            controller: widget.textEditingController,
            keyboardType: widget.textInputType,
            cursorColor: Colors.black,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xffF0F0F0),
              contentPadding: EdgeInsets.only(left: 2.0, top: 6.0, bottom: 6.0),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide(color: Colors.pink, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide(color: Color(0xffF0F0F0), width: 1.0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide(color: Colors.transparent, width: 1.0),
              ),
              border: InputBorder.none,
              isDense: true,
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Colors.black38, fontSize: 14.0),
            ),
          ),
        ],
      ),
    );
  }
}
