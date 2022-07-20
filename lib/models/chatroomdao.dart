import 'package:firebase_database/firebase_database.dart';
import 'package:find_my_pet_sg/models/chatroom.dart';

class ChatroomDao {
  final DatabaseReference _chatroomRef =
  FirebaseDatabase(databaseURL: 'https://findmypetsg-default-rtdb.asia-southeast1.firebasedatabase.app')
      .ref().child('chatroom');

  void saveChatroom(Chatroom chatroom) {
    _chatroomRef.push().set(chatroom.toJson());
  }

  void addChatroom(String user, Chatroom chatroom) {
    _chatroomRef.child(user).push().set(chatroom.toJson());
  }

  Query getUserQuery() {
    return _chatroomRef;
  }

  void addEmpty(String user) {
    _chatroomRef.child(user).set("");
  }

}