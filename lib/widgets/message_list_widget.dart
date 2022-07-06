

import 'package:find_my_pet_sg/modal/chatroom.dart';
import 'package:find_my_pet_sg/modal/person.dart';
import 'package:find_my_pet_sg/widgets/chat_body_widget.dart';
import 'package:find_my_pet_sg/widgets/chat_header_widget.dart';
import 'package:find_my_pet_sg/widgets/message_list_widget.dart';
import 'package:find_my_pet_sg/widgets/message_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:find_my_pet_sg/helper/homehelper.dart';
import 'package:provider/provider.dart';
import 'package:find_my_pet_sg/modal/messages.dart';
import 'package:intl/intl.dart';
import 'package:find_my_pet_sg/widgets/widget.dart';
import 'package:find_my_pet_sg/modal/message_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:find_my_pet_sg/modal/messagedao.dart';
import 'package:find_my_pet_sg/widgets/message_widget.dart';
import 'package:flutter/scheduler.dart';

class MessageList extends StatefulWidget {
  final messageDao;
  final ScrollController scrollController;

  const MessageList({
    required this.messageDao,
    required this.scrollController,
    key,
  }) : super(key: key);

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FirebaseAnimatedList(
        physics: BouncingScrollPhysics(),
        controller: widget.scrollController,
        query: widget.messageDao.getOwnMessageQuery(),
        itemBuilder: (context, snapshot, animation, index) {
          final json = snapshot.value as Map<dynamic, dynamic>;
          final message = Message.fromJson(json);
          return MessageWidget(message: message.text, isMe: message.isMe, date: message.date, messageDao: widget.messageDao);
        },
      ),
    );
  }
}

