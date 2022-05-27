import 'package:find_my_pet_sg/modal/person.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_pet_sg/modal/message.dart';
import 'package:find_my_pet_sg/helper/util.dart';
import 'package:find_my_pet_sg/data.dart';

class FirebaseApi {
  static Stream<List<Person>> getUsers() => FirebaseFirestore.instance
      .collection('users')
      .orderBy(UserField.lastMessageTime, descending: true)
      .snapshots()
      .transform(Util.transformer(Person.fromJson));

  static Future uploadMessage(String userId, String message) async {
    final refMessages =
    FirebaseFirestore.instance.collection('chats/$userId/messages');

    final newMessage = Message(
      userId: myId,
      urlAvatar: myUrlAvatar,
      username: myUsername,
      message: message,
      createdAt: DateTime.now(),
    );
    await refMessages.add(newMessage.toJson());

    final refUsers = FirebaseFirestore.instance.collection('users');
    await refUsers
        .doc(userId)
        .update({UserField.lastMessageTime: DateTime.now()});
  }

  static Stream<List<Message>> getMessages(String ? userId) =>
      FirebaseFirestore.instance
          .collection('chats/$userId/messages')
          .orderBy(MessageField.createdAt, descending: true)
          .snapshots()
          .transform(Util.transformer(Person.fromJson));

  static Future addRandomUsers(List<Person> users) async {
    final refUsers = FirebaseFirestore.instance.collection('users');

    final allUsers = await refUsers.get();
    if (allUsers.size != 0) {
      return;
    } else {
      for (final user in users) {
        final userDoc = refUsers.doc();
        final newUser = user.copyWith(userId: userDoc.id);

        await userDoc.set(newUser.toJson());
      }
    }
  }
}