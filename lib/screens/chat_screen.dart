import 'dart:io';

import 'package:find_my_pet_sg/models/message_model.dart';
import 'package:find_my_pet_sg/models/messagedao.dart';
import 'package:find_my_pet_sg/services/storage_methods.dart';
import 'package:find_my_pet_sg/widgets/message_list_widget.dart';
import 'package:find_my_pet_sg/widgets/send_message_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      final ownMessage =
          Message(_messageInputController.text, DateTime.now(), true, '');
      final otherMessage =
          Message(_messageInputController.text, DateTime.now(), false, '');
      widget.messageDao.saveOwnMessage(ownMessage);
      widget.messageDao.saveOtherMessage(otherMessage);
      _messageInputController.clear();
    } else if (_canSendMessage() && file.path != 'empty') {
      StorageMethods storage = StorageMethods(username: widget.username);
      String imageUrl = (await storage.uploadImageToStorage(
          'messageImages', file.readAsBytesSync()))[0];
      final ownMessage =
          Message(_messageInputController.text, DateTime.now(), true, imageUrl);
      final otherMessage = Message(
          _messageInputController.text, DateTime.now(), false, imageUrl);
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
          MessageList(
              messageDao: widget.messageDao,
              scrollController: _scrollController,
              circleAvatar: widget.circleAvatar),
          SendMessageWidget(
            sendMessage: _sendMessage,
            textEditingController: _messageInputController,
            canSendMessage: _canSendMessage,
          ),
        ],
      ),
    );
  }
}
