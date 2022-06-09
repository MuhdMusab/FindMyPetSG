import 'package:firebase_database/firebase_database.dart';
import 'package:find_my_pet_sg/modal/message2.dart';

class MessageDao {
  final DatabaseReference _messagesRef =
  FirebaseDatabase(databaseURL: 'https://findmypetsg-default-rtdb.asia-southeast1.firebasedatabase.app')
  .ref().child('messages');

  void saveMessage(Message2 message) {
    _messagesRef.push().set(message.toJson());
  }

  Query getMessageQuery() {
    return _messagesRef;
  }

}