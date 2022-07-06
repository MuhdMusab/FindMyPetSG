import 'package:find_my_pet_sg/widgets/chat_body_widget.dart';
import 'package:find_my_pet_sg/widgets/chat_header_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/cupertino.dart';

class SearchScreen extends StatefulWidget {
  QueryDocumentSnapshot<Object?>? _user;

  SearchScreen(QueryDocumentSnapshot<Object?>? user) {
    this._user = user;
  }

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with AutomaticKeepAliveClientMixin<SearchScreen> {

  @override
  bool get wantKeepAlive => true;

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
