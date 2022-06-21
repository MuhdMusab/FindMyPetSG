import 'package:flutter/foundation.dart';
import 'package:find_my_pet_sg/helper/util.dart';

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

  Person copyWith({
    String ? userId,
    String ? name,
    String ? urlAvatar,
    String ? lastMessageTime,
  }) =>
      Person(
        userId: userId ?? this.userId,
        name: name ?? this.name,
        urlAvatar: urlAvatar ?? this.urlAvatar,
        lastMessageTime: (lastMessageTime ?? this.lastMessageTime) as DateTime,
      );

  static Person fromJson(Map<String, dynamic> json) => Person(
    userId : json['idUser'],
    name: json['name'],
    urlAvatar: json['urlAvatar'],
    lastMessageTime: Util.toDateTime(json['lastMessageTime']),
  );

  Map<String, dynamic> toJson() => {
    'idUser': userId,
    'name': name,
    'urlAvatar': urlAvatar,
    'lastMessageTime': Util.fromDateTimeToJson(lastMessageTime!),
  };
}