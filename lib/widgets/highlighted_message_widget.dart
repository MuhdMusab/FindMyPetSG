import 'dart:ui';
import 'package:find_my_pet_sg/config/constants.dart';
import 'package:find_my_pet_sg/screens/create_lost_post_screen.dart';
import 'package:find_my_pet_sg/screens/create_found_post_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_pet_sg/modal/messagedao.dart';
import 'package:find_my_pet_sg/services/storage_methods.dart';
import 'package:flutter/material.dart';
import 'package:find_my_pet_sg/modal/message_model.dart';
import 'package:intl/intl.dart';

class HighlightedMessageWidget extends StatefulWidget {
  final String message;
  final bool isMe;
  final DateTime date;
  final MessageDao messageDao;

  const HighlightedMessageWidget({
    Key? key,
    required this.message,
    required this.isMe,
    required this.date,
    required this.messageDao
  }) : super(key: key);

  @override
  _HighlightedMessageWidgetState createState() => _HighlightedMessageWidgetState();
}

class _HighlightedMessageWidgetState extends State<HighlightedMessageWidget> {



  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.75,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: widget.isMe ? pink() : Colors.grey[100],
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 5), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: widget.isMe ? Colors.white : Colors.black,
                ),
              ),
             SizedBox(height: 10,),
             Align(
               alignment: widget.isMe ?  Alignment.bottomRight : Alignment.bottomLeft,
               child: Text(
                 DateFormat('MM-dd-yyyy HH:mm').format(widget.date).toString(),
                 style: TextStyle(
                   color: widget.isMe ? Colors.white : Colors.black,
               ),
               ),
             )
            ],
          ),
        ),
      ],
    );

  }

}

