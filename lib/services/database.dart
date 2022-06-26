import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_pet_sg/modal/RealtimeUser.dart';
import 'package:find_my_pet_sg/modal/chatroom.dart';
import 'package:find_my_pet_sg/modal/chatroomdao.dart';
import 'package:find_my_pet_sg/modal/realtimeuserdao.dart';

class DatabaseMethods {
  static Future<void> addUserInfo(userData, String username) async {
    FirebaseFirestore.instance.collection("users").doc(username).set(userData).catchError((e) {
      print(e.toString());
    });
  }

  static Future<void> addPost(String username, String post, int postIndex) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection("users").doc(username).get();
    Map<String, dynamic> mapOfPosts = snapshot['posts'];
    if (mapOfPosts[postIndex.toString()] == null) {
      mapOfPosts[postIndex.toString()] = [post];
    } else {
      mapOfPosts[postIndex.toString()].add(post);
    }
    FirebaseFirestore.instance.collection("users").doc(username).update({"posts": mapOfPosts});
  }

  static Future<void> editPostAtIndex(String username, String post, int mapIndex, int postIndex) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection("users").doc(username).get();
    Map<String, dynamic> mapOfPosts = snapshot['posts'];
    if (mapOfPosts[mapIndex.toString()] == null) {
      mapOfPosts[mapIndex.toString()] = [post];
    } else {
      mapOfPosts[mapIndex.toString()][postIndex] = post;
    }
    FirebaseFirestore.instance.collection("users").doc(username).update({"posts": mapOfPosts});
  }

  static Future<Map<String, dynamic>> getUserPosts(String username) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection("users").doc(username).get(); //where("name", isEqualTo: username). .catchError((e) {
    Map<String, dynamic> mapOfPosts = snapshot['posts'];
    return mapOfPosts;
  }

  static Future<int> getPostsLength(String username) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection("users").doc(username).get();
    Map<String, dynamic> mapOfPosts = snapshot['posts'];
    return mapOfPosts.length;
  }

  static Future<void> addStorageReference(String username, String ref, int refIndex) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection("users").doc(username).get();
    Map<String, dynamic> mapOfStorageRefs = snapshot['storageRefs'];
    if (mapOfStorageRefs[refIndex.toString()] == null) {
      mapOfStorageRefs[refIndex.toString()] = [ref];
    } else {
      mapOfStorageRefs[refIndex.toString()].add(ref);
    }
    FirebaseFirestore.instance.collection("users").doc(username).update({"storageRefs": mapOfStorageRefs});
  }

  static Future<void> editStorageReferenceAtIndex(String username, String ref, int mapIndex, int refIndex) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection("users").doc(username).get();
    Map<String, dynamic> mapOfStorageRefs = snapshot['storageRefs'];
    if (mapOfStorageRefs[mapIndex.toString()] == null) {
      mapOfStorageRefs[mapIndex.toString()] = [ref];
    } else {
      mapOfStorageRefs[mapIndex.toString()][refIndex] = ref;
    }
    FirebaseFirestore.instance.collection("users").doc(username).update({'storageRefs': mapOfStorageRefs});
  }

  static Future<String> getStorageReferenceAtIndex(String username, int mapIndex, int refIndex) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection("users").doc(username).get();
    Map<String, dynamic> mapOfStorageRefs = snapshot['storageRefs'];
    return mapOfStorageRefs[mapIndex.toString()][refIndex];
  }

  static Future<Map<String, dynamic>> getUserStorageReference(String username) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection("users").doc(username).get();
    Map<String, dynamic> mapOfStorageRefs = snapshot['storageRefs'];
    return mapOfStorageRefs;
  }

  static Future<int> getStorageReferenceLength(String username) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection("users").doc(username).get();
    Map<String, dynamic> mapOfStorageRefs = snapshot['storageRefs'];
    return mapOfStorageRefs.length;
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