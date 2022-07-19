class Message {
  final String text;
  final DateTime date;
  final bool isMe;
  final String imageUrl;

  Message(this.text, this.date, this.isMe, this.imageUrl);

  Message.fromJson(Map<dynamic, dynamic> json)
      : date = DateTime.parse(json['date'] as String),
        text = json['text'] as String,
        isMe = json['isMe'] as bool,
        imageUrl = json['imageUrl'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'date': date.toString(),
    'text': text,
    'isMe': isMe,
    'imageUrl' : imageUrl,
  };
}

