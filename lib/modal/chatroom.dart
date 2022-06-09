class Chatroom {
  final String username;

  Chatroom(this.username);

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'username': username,
  };

  Chatroom.fromJson(Map<dynamic, dynamic> json)
      : username = json['username'] as String;

}