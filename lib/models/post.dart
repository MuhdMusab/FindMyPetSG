import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String type;
  final String name;
  final String location;
  String? breed;
  final String description;
  final String date;
  final String postId;
  final List<String> photoUrls;
  final bool isMale;
  int? age;
  int? reward;
  final String username;

  Post({
    required this.type,
    required this.name,
    required this.location,
    this.breed,
    required this.description,
    required this.date,
    required this.postId,
    required this.photoUrls,
    required this.isMale,
    this.age,
    this.reward,
    required this.username,
  });

  Map<String, dynamic> lostToJson() => {
    "type": type,
    "name": name,
    "location": location,
    "breed": breed,
    "description": description,
    "date": date,
    "postId": postId,
    "photoUrls": photoUrls,
    "isMale": isMale,
    "age": age,
    "reward": reward,
    "username": username,
  };

  Map<String, dynamic> foundToJson() => {
    "type": type,
    "name": name,
    "location": location,
    "description": description,
    "date": date,
    "postId": postId,
    "photoUrls": photoUrls,
    "isMale": isMale,
    "username": username,
  };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      type: snapshot['type'],
      name: snapshot['name'],
      location: snapshot['location'],
      breed: snapshot['breed'],
      description: snapshot['description'],
      date: snapshot['date'],
      postId: snapshot['postId'],
      photoUrls: snapshot['photoUrls'],
      isMale: snapshot['isMale'],
      age: snapshot['age'],
      reward: snapshot['reward'],
      username: snapshot['username'],
    );
  }
}