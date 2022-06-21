import 'package:flutter/material.dart';
import 'package:find_my_pet_sg/helper/util.dart';

class MessageField {
  static final String createdAt = 'createdAt';
}

class Message {
  final String ? userId;
  final String ? urlAvatar;
  final String ? username;
  final String ? message;
  final DateTime ? createdAt;

  const Message({
    @required this.userId,
    @required this.urlAvatar,
    @required this.username,
    @required this.message,
    @required this.createdAt,
  });

  static Message fromJson(Map<String, dynamic> json) => Message(
    userId: json['idUser'],
    urlAvatar: json['urlAvatar'],
    username: json['username'],
    message: json['message'],
    createdAt: Util.toDateTime(json['createdAt']),
  );

  Map<String, dynamic> toJson() => {
    'idUser': userId,
    'urlAvatar': urlAvatar,
    'username': username,
    'message': message,
    'createdAt': Util.fromDateTimeToJson(createdAt!),
  };
}