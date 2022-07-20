class Messages {
  final String message;
  final String senderUsername;
  final DateTime sentAt;

  Messages({
    required this.message,
    required this.senderUsername,
    required this.sentAt,
  });

  factory Messages.fromJson(Map<String, dynamic> message) {
    return Messages(
      message: message['message'],
      senderUsername: message['senderUsername'],
      sentAt: DateTime.fromMillisecondsSinceEpoch(message['sentAt']),
    );
  }
}