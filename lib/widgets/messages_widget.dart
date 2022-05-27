import 'package:find_my_pet_sg/data.dart';
import 'package:flutter/material.dart';
import 'package:find_my_pet_sg/helper/firebase_api.dart';
import 'package:find_my_pet_sg/modal/message.dart';
import 'package:find_my_pet_sg/widgets/message_widget.dart';

class MessagesWidget extends StatelessWidget {
  final String ? userId;

  const MessagesWidget({
    @required this.userId,
    Key ? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder<List<Message>>(
    stream: FirebaseApi.getMessages(userId == null ? null : userId),
    builder: (context, snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return Center(child: CircularProgressIndicator());
        default:
          if (snapshot.hasError) {
            return buildText('Something Went Wrong Try later');
          } else {
            final messages = snapshot.data;

            return messages!.isEmpty
                ? buildText('Say Hi..')
                : ListView.builder(
              physics: BouncingScrollPhysics(),
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];

                return MessageWidget(
                  message: message,
                  isMe: message.userId == myId,
                );
              },
            );
          }
      }
    },
  );

  Widget buildText(String text) => Center(
    child: Text(
      text,
      style: TextStyle(fontSize: 24),
    ),
  );
}