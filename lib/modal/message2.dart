class Message2 {
  final String text;
  final DateTime date;
  final bool isMe;

  Message2(this.text, this.date, this.isMe);

  Message2.fromJson(Map<dynamic, dynamic> json)
      : date = DateTime.parse(json['date'] as String),
        text = json['text'] as String,
        isMe = json['isMe'] as bool;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'date': date.toString(),
    'text': text,
    'isMe': isMe,
  };
}

