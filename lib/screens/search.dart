import 'package:find_my_pet_sg/modal/chatroom.dart';
import 'package:find_my_pet_sg/modal/person.dart';
import 'package:find_my_pet_sg/services/notification_service.dart';
import 'package:find_my_pet_sg/widgets/chat_body_widget.dart';
import 'package:find_my_pet_sg/widgets/chat_header_widget.dart';
import 'package:find_my_pet_sg/widgets/message_list_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:find_my_pet_sg/helper/homehelper.dart';
import 'package:provider/provider.dart';
import 'package:find_my_pet_sg/modal/messages.dart';
import 'package:intl/intl.dart';
import 'package:find_my_pet_sg/widgets/widget.dart';
import 'package:find_my_pet_sg/modal/message2.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:find_my_pet_sg/modal/messagedao.dart';
import 'package:find_my_pet_sg/widgets/message_widget.dart';

class SearchScreen extends StatefulWidget {
  QueryDocumentSnapshot<Object?>? _user;

  SearchScreen(QueryDocumentSnapshot<Object?>? user) {
    this._user = user;
  }

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}
//http://10.0.2.2:3000
//'http://localhost:3000'
//'http://192.168.1.255:3000'
class _SearchScreenState extends State<SearchScreen> with AutomaticKeepAliveClientMixin<SearchScreen> {

  @override
  bool get wantKeepAlive => true;

  // void initState() {
  //   super.initState();
  //   _activateListeners();
  // }
  //
  // void _activateListeners() {
  //   final String username = widget._user!['name'].toString();
  //   FirebaseDatabase.instance.ref().child(username).onChildChanged.listen((event) {
  //     final String message = event.snapshot.value as String;
  //     NotificationService().showNotification(1, "new message ", message, 2);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    //WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    final String username = widget._user!['name'].toString();
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.15),
      body: StreamBuilder(
        stream: FirebaseDatabase(databaseURL: 'https://findmypetsg-default-rtdb.asia-southeast1.firebasedatabase.app')
            .ref().child('chatroom').child(username).onValue,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError || snapshot.data == null) {
                print(snapshot.error);
                return Text('Something went wrong try again later');
              } else {
                DatabaseEvent tempp = snapshot.data as DatabaseEvent;
                if(tempp.snapshot.value!.toString() == "") {
                  return ChatHeaderWidget(users: [], username: "empty",);
                } else {
                  final chatrooms = Map<dynamic, dynamic>.from(
                      (snapshot.data! as dynamic).snapshot.value);
                  List temp = [];
                  Map<dynamic, dynamic>? otherChatters;
                  chatrooms.forEach((key, value) {
                    otherChatters = Map<String, dynamic>.from(value);
                    temp.add(otherChatters?.values.first);
                  });
                  final chat = Chatroom.fromJson(otherChatters!);
                  return Column(
                    children: [
                      ChatHeaderWidget(users: temp, username: username),
                      ChatBodyWidget(users: temp, username: username),
                    ],
                  );
                }
              }
          }
        }

      ),
    );
  }
}
