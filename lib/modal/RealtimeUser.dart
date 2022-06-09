class RealtimeUser {
  final String username;

  RealtimeUser(this.username);

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'username': username,
  };
}