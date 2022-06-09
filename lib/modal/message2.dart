class Message2 {
  final String text;
  final DateTime date;

  Message2(this.text, this.date);

  Message2.fromJson(Map<dynamic, dynamic> json)
      : date = DateTime.parse(json['date'] as String),
        text = json['text'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'date': date.toString(),
    'text': text,
  };
}

