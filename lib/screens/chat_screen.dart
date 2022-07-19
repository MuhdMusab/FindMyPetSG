import 'dart:io';

import 'package:find_my_pet_sg/modal/chatroom.dart';
import 'package:find_my_pet_sg/modal/person.dart';
import 'package:find_my_pet_sg/services/storage_methods.dart';
import 'package:find_my_pet_sg/widgets/chat_body_widget.dart';
import 'package:find_my_pet_sg/widgets/chat_header_widget.dart';
import 'package:find_my_pet_sg/widgets/message_list_widget.dart';
import 'package:find_my_pet_sg/widgets/message_widget.dart';
import 'package:find_my_pet_sg/widgets/send_message_widget.dart';
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

class ChatScreen extends StatefulWidget {
  final String username;
  final MessageDao messageDao;
  final CircleAvatar circleAvatar;

  const ChatScreen({
    required this.username,
    required this.messageDao,
    required this.circleAvatar,
    key,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageInputController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void _sendMessage(File file) async {
    if (_canSendMessage() && file.path == 'empty') {

      final ownMessage = Message(_messageInputController.text, DateTime.now(), true, '');
      final otherMessage = Message(_messageInputController.text, DateTime.now(), false, '');
      widget.messageDao.saveOwnMessage(ownMessage);
      widget.messageDao.saveOtherMessage(otherMessage);
      _messageInputController.clear();
    } else if (_canSendMessage() && file.path != 'empty') {
      StorageMethods storage = StorageMethods(username: widget.username);
      String imageUrl = (await storage.uploadImageToStorage('messageImages', file.readAsBytesSync()))[0];
      final ownMessage = Message(_messageInputController.text, DateTime.now(), true, imageUrl);
      final otherMessage = Message(_messageInputController.text, DateTime.now(), false, imageUrl);
      widget.messageDao.saveOwnMessage(ownMessage);
      widget.messageDao.saveOtherMessage(otherMessage);
      _messageInputController.clear();
    }
  }

  bool _canSendMessage() => _messageInputController.text.length > 0;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.username,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          MessageList(messageDao: widget.messageDao, scrollController: _scrollController, circleAvatar: widget.circleAvatar),
          SendMessageWidget(
            sendMessage: _sendMessage,
            textEditingController: _messageInputController,
            canSendMessage: _canSendMessage,
          ),
        ],
      ),
      // body: Padding(
      //   padding: EdgeInsets.all(16.0),
      //   child: Column(
      //     children: [
      //       _getMessageList(),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           Flexible(
      //             child: Padding(
      //               padding: const EdgeInsets.symmetric(horizontal: 12.0),
      //               child: TextField(
      //                 keyboardType: TextInputType.text,
      //                 controller: _messageInputController,
      //                 onChanged: (text) => setState(() {}),
      //                 onSubmitted: (input) {
      //                   _sendMessage();
      //                 },
      //                 decoration:
      //                 const InputDecoration(hintText: 'Enter new message'),
      //               ),
      //             ),
      //           ),
      //           IconButton(
      //               icon: Icon(_canSendMessage()
      //                   ? CupertinoIcons.arrow_right_circle_fill
      //                   : CupertinoIcons.arrow_right_circle),
      //               onPressed: () {
      //                 _sendMessage();
      //               })
      //         ],
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
