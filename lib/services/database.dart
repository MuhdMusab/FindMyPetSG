import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_pet_sg/modal/RealtimeUser.dart';
import 'package:find_my_pet_sg/modal/chatroom.dart';
import 'package:find_my_pet_sg/modal/chatroomdao.dart';
import 'package:find_my_pet_sg/modal/realtimeuserdao.dart';

class DatabaseMethods {
  static Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance.collection("users").add(userData).catchError((e) {
      print(e.toString());
    });
  }


  Future<QuerySnapshot> getUserInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }
  
  static Future<bool> containsUsername(String username) async {
    return (await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username).get()).docs.length > 0;
  }

  static Future<bool> containsEmail(String email) async {
    return (await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email).get()).docs.length > 0;
  }

  Future<QuerySnapshot> getUserByUsername(String username) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection("users")
        .where('userName', isEqualTo: searchField)
        .get();
  }

  Future<void> addChatRoom(chatRoom, chatRoomId) {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  getChats(String chatRoomId) async{
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }


  Future<void> addMessage(String chatRoomId, chatMessageData){
    return FirebaseFirestore.instance.collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData).catchError((e){
      print(e.toString());
    });
  }

  getUserChats(String itIsMyName) async {
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }

  static void addRealtimeUser(String username) {
      final user = RealtimeUser(username);
      final realtimeUserDao = RealtimeUserDao();
      final chatroomDao = ChatroomDao();
      chatroomDao.addEmpty(username);
      realtimeUserDao.saveUser(user);
  }

  getUsernameFromEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where('email', isEqualTo : email)
        .snapshots();
  }

}