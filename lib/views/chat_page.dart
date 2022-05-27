import 'package:find_my_pet_sg/modal/person.dart';
import 'package:flutter/material.dart';
import 'package:find_my_pet_sg/widgets/profile_header_widget.dart';
import 'package:find_my_pet_sg/widgets/messages_widget.dart';
import 'package:find_my_pet_sg/widgets/new_message_widget.dart';

class ChatPage extends StatefulWidget {
  final Person ? user;

  const ChatPage({
    @required this.user,
    Key ? key,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) =>
      Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.blue,
        body: SafeArea(
          child: Column(
            children: [
              ProfileHeaderWidget(name: widget.user!.name),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: MessagesWidget(userId: widget.user?.userId ?? null),
                ),
              ),
              NewMessageWidget(userId: widget.user!.userId)
            ],
          ),
        ),
      );
}