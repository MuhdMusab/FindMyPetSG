import 'package:find_my_pet_sg/modal/messagedao.dart';
import 'package:find_my_pet_sg/services/storage_methods.dart';
import 'package:flutter/material.dart';
import 'package:find_my_pet_sg/modal/message_model.dart';
import 'package:intl/intl.dart';

class MessageWidget extends StatelessWidget {
  final String message;
  final bool isMe;
  final DateTime date;
  final MessageDao messageDao;
  final CircleAvatar circleAvatar;

  const MessageWidget({
    required this.message,
    required this.isMe,
    required this.date,
    required this.messageDao,
    required this.circleAvatar,
  });

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(12);
    final borderRadius = BorderRadius.all(radius);
    final StorageMethods storage = StorageMethods(username: messageDao.otherUsername!);
    return Column(
      children: [
        Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 12,),
            if (!isMe)
              circleAvatar,
              // FutureBuilder(
              //     future: storage.downloadURL(),
              //     builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              //       if (snapshot.connectionState == ConnectionState.done &&
              //           snapshot.hasData) {
              //         return CircleAvatar(
              //           radius: 25,
              //           backgroundImage: NetworkImage(snapshot.data!),
              //         );
              //       } else {
              //         return CircleAvatar(
              //           radius: 25,
              //           backgroundImage: AssetImage("assets/images/default_user_icon.png"),
              //         );
              //       }
              //     }
              // ),
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              constraints: BoxConstraints(maxWidth: 200),
              decoration: BoxDecoration(
                color: isMe ? Color(0xfff26579) : Colors.grey[100],
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
                DateFormat('kk:mma').format(date).toString(),
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
      children: <Widget>[
        Text(
          message,
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
          ),
          textAlign: isMe ? TextAlign.end : TextAlign.start,
        ),

      ],
    );
  }
}
