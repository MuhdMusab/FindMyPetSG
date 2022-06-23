import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String name;
  final String location;
  final String breed;
  final String description;
  final String date;
  final String postId;
  final String photoUrl;
  final bool isMale;
  final int age;
  final int reward;
  final String username;

  const Post({
    required this.name,
    required this.location,
    required this.breed,
    required this.description,
    required this.date,
    required this.postId,
    required this.photoUrl,
    required this.isMale,
    required this.age,
    required this.reward,
    required this.username,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "location": location,
    "breed": breed,
    "description": description,
    "date": date,
    "postId": postId,
    "photoUrl": photoUrl,
    "isMale": isMale,
    "age": age,
    "reward": reward,
    "username": username,
  };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      name: snapshot['name'],
      location: snapshot['location'],
      breed: snapshot['breed'],
      description: snapshot['description'],
      date: snapshot['date'],
      postId: snapshot['postId'],
      photoUrl: snapshot['photoUrl'],
      isMale: snapshot['isMale'],
      age: snapshot['age'],
      reward: snapshot['reward'],
      username: snapshot['username'],
    );
  }
}