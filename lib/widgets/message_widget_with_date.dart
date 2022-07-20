import 'package:find_my_pet_sg/models/messagedao.dart';
import 'package:find_my_pet_sg/config/constants.dart';
import 'package:find_my_pet_sg/services/storage_methods.dart';
import 'package:flutter/material.dart';
import 'package:find_my_pet_sg/models/message_model.dart';
import 'package:intl/intl.dart';

class MessageWidgetWithDate extends StatelessWidget {
  final String message;
  final bool isMe;
  final DateTime date;
  final MessageDao messageDao;
  final CircleAvatar circleAvatar;
  String? imageUrl;

  MessageWidgetWithDate({
    required this.message,
    required this.isMe,
    required this.date,
    required this.messageDao,
    required this.circleAvatar,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(12);
    final borderRadius = BorderRadius.all(radius);
    final StorageMethods storage = StorageMethods(username: messageDao.otherUsername!);
    String utcDate = date.toString().substring(0,10);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                utcDate.substring(8,10) + utcDate.substring(4,8) + utcDate.substring(0,4),
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 12,),
            if (!isMe)
              circleAvatar,
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              constraints: BoxConstraints(maxWidth: 200),
              decoration: BoxDecoration(
                color: isMe ? pink() : Colors.grey[100],
                borderRadius: isMe
                    ? borderRadius.subtract(BorderRadius.only(bottomRight: radius))
                    : borderRadius.subtract(BorderRadius.only(bottomLeft: radius)),
              ),
              child: buildMessage(),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
          child: Align(
              alignment: isMe ? Alignment.bottomRight : Alignment.bottomLeft,
              child: Text(
                DateFormat('hh:mma').format(date).toString(),
                style: TextStyle(color: Colors.grey),
              )),
        ),
      ],
    );
  }

  Widget buildMessage() {
    //callback();
    return Column(
      crossAxisAlignment:
      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children:
      imageUrl != ''
          ? <Widget>[
        Image.network(imageUrl!),
        Text(
          message,
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
          ),
          textAlign: isMe ? TextAlign.end : TextAlign.start,
        ),
      ]
          : <Widget>[
        Text(
          message,
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
          ),
          textAlign: isMe ? TextAlign.end : TextAlign.start,
        ),
      ],

      // <Widget>[
      //   Text(
      //     message,
      //     style: TextStyle(
      //       color: isMe ? Colors.white : Colors.black,
      //     ),
      //     textAlign: isMe ? TextAlign.end : TextAlign.start,
      //   ),
      // ],
    );
  }
}
