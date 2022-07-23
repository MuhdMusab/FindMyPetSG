import 'dart:ui';
import 'package:find_my_pet_sg/config/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationsDeniedDialog extends StatefulWidget {

  const NotificationsDeniedDialog({
    Key? key,
  }) : super(key: key);

  @override
  _NotificationsDeniedDialogState createState() => _NotificationsDeniedDialogState();
}

class _NotificationsDeniedDialogState extends State<NotificationsDeniedDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
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
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                const BoxShadow(
                    color: Colors.black, offset: const Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Text(
                  'You have not enabled notifications',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, ),
                ),
              ),
              Center(
                child: Text(
                  'permissions for this app',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}
