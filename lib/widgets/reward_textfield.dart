import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config/constants.dart';

class RewardTextfield extends StatefulWidget {
  final String infoText;
  final String hintText;
  final int maxLines;
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  const RewardTextfield({
    Key? key,
    required this.hintText,
    required this.textEditingController,
    required this.textInputType,
    required this.infoText,
    required this.maxLines,
  }) : super(key: key);

  @override
  State<RewardTextfield> createState() => _RewardTextfield();
}

class _RewardTextfield extends State<RewardTextfield> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.infoText,
                style: TextStyle(fontSize: 16, color: Colors.blueGrey),
              ),
            ],
          ),
          Stack(
            children: [
              TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  new LengthLimitingTextInputFormatter(rewardCharacterLimit)
                ],
                style: TextStyle(fontSize: 20),
                maxLines: widget.maxLines,
                controller: widget.textEditingController,
                keyboardType: widget.textInputType,
                cursorColor: Colors.black,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                  EdgeInsets.only(left: 25.0, top: 15.5, bottom: 15.5),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.pink, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                    BorderSide(color: Colors.blueGrey.shade200, width: 1.5),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                    BorderSide(color: Colors.transparent, width: 1.5),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  hintText: widget.hintText,
                  hintStyle: TextStyle(color: Colors.black54, fontSize: 16.0),
                ),
              ),
              Positioned(
                left: 0,
                bottom: 12.5,
                child: Icon(
                  Icons.attach_money_sharp,
                  color: Colors.green,
                  size: 26,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}