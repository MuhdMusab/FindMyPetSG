import 'package:firebase_database/firebase_database.dart';
import 'package:find_my_pet_sg/models/message_model.dart';

class MessageDao {
  String? ownUsername;
  String? otherUsername;

  MessageDao(String ownUsername, String otherUsername) {
    this.ownUsername = ownUsername;
    this.otherUsername = otherUsername;
  }

  DatabaseReference getOwnMessageRef() {
    return FirebaseDatabase(
        databaseURL: 'https://findmypetsg-default-rtdb.asia-southeast1.firebasedatabase.app')
        .ref().child(ownUsername!).child(otherUsername!).child('messages');
  }

  DatabaseReference getOwnRef() {
    return FirebaseDatabase(
        databaseURL: 'https://findmypetsg-default-rtdb.asia-southeast1.firebasedatabase.app')
        .ref().child(ownUsername!);
  }

  DatabaseReference getOtherMessageRef() {
    return FirebaseDatabase(
        databaseURL: 'https://findmypetsg-default-rtdb.asia-southeast1.firebasedatabase.app')
        .ref().child(otherUsername!).child(ownUsername!).child('messages');
  }

  void saveOwnMessage(Message message) {
    getOwnMessageRef().push().set(message.toJson());
  }

  void saveOtherMessage(Message message) {
    getOtherMessageRef().push().set(message.toJson());
  }

  Query getOwnMessageQuery() {
    return getOwnMessageRef();
  }

  Query getOtherMessageQuery() {
    return getOtherMessageRef();
  }

  Query getOwnChatQuery() {
    return FirebaseDatabase(
        databaseURL: 'https://findmypetsg-default-rtdb.asia-southeast1.firebasedatabase.app')
        .ref().child(ownUsername!).child(otherUsername!);
  }

  Query getOtherChatQuery() {
    return FirebaseDatabase(
        databaseURL: 'https://findmypetsg-default-rtdb.asia-southeast1.firebasedatabase.app')
        .ref().child(otherUsername!).child(ownUsername!);
  }

  Future<DataSnapshot> getMostRecentMessage() async {
    return getOwnMessageQuery().orderByKey().limitToLast(1).get();
  }
}
