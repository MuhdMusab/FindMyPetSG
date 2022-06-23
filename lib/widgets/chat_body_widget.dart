import 'package:find_my_pet_sg/modal/messagedao.dart';
import 'package:find_my_pet_sg/screens/chat_screen.dart';
import 'package:find_my_pet_sg/services/notification_service.dart';
import 'package:find_my_pet_sg/services/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatBodyWidget extends StatefulWidget {
  final List users;
  final String username;

  const ChatBodyWidget({
    required this.users,
    required this.username,
    key,
  }) : super(key: key);

  @override
  State<ChatBodyWidget> createState() => _ChatBodyWidgetState();
}

class _ChatBodyWidgetState extends State<ChatBodyWidget> {

  void initState() {
    super.initState();
    _activateListeners();
  }

  void _activateListeners() {
    MessageDao(widget.username, "none").getOwnRef().onChildChanged.listen((event) {
      if (mounted) {
        setState(() {});
      } else {
        return;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: buildChats(),
      ),
    );
  }

  Widget buildChats() => ListView.separated(
    separatorBuilder: (context, index) {
      return Divider();
    },
    physics: BouncingScrollPhysics(),
    itemBuilder: (context, index) {
      final otherUser = widget.users[index];
      Storage storage = Storage(otherUser);
      MessageDao messageDao = MessageDao(widget.username, otherUser);
      return Container(
        height: 75,
        child: ListTile(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChatScreen(username: otherUser, messageDao: MessageDao(widget.username, otherUser),),
            ));
          },
          leading: FutureBuilder(
              future: storage.downloadURL(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(snapshot.data!),
                  );
                } else {
                  return CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage("assets/images/default_user_icon.png"),
                  );
                }
              }
          ),
          title: Text(otherUser),
          subtitle: FutureBuilder(
            future: messageDao.getMostRecentMessage(),
            builder: (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {

              if (snapshot.data != null && snapshot.data!.value != null) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final map = (snapshot.data!.value as Map<dynamic, dynamic>).values.first;
                  if (map['isMe']) {
                    return Text("You: " + map['text'], maxLines: 1,);
                  } else {
                    NotificationService().showNotification(1, "new message from " + otherUser, map['text'], 2);
                    return Text(map['text'], maxLines: 1,);
                  }

                } else {
                  final map = (snapshot.data!.value as Map<dynamic, dynamic>).values.first;
                  if (map['isMe']) {
                    return Text("You: " + map['text'], maxLines: 1,);
                  } else {
                    NotificationService().showNotification(1, "new message from " + otherUser, map['text'], 2);
                    return Text(map['text'], maxLines: 1,);
                  }
                }

              } else {
                return Text("");
              }
            }

            ,
          ),
        ),
      );
    },
    itemCount: widget.users.length,
  );
}
