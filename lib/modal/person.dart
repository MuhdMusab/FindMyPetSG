import 'package:flutter/foundation.dart';

class UserField {
  static final String lastMessageTime = 'lastMessageTime';
}

class Person {
  final String ? userId;
  final String ? name;
  final String ? urlAvatar;
  final DateTime ? lastMessageTime;

  Person({
    this.userId,
    @required this.name,
    @required this.urlAvatar,
    @required this.lastMessageTime,
  });
}