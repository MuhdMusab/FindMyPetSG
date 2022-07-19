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
  final double latitude;
  final double longtitude;
  final DateTime dateTimePosted;

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
    required this.latitude,
    required this.longtitude,
    required this.dateTimePosted,
  });

  Map<String, dynamic> lostToJson() => {
        "type": type,
        "name": name,
        "location": location,
        "latitude": latitude,
        "longtitude": longtitude,
        "breed": breed,
        "description": description,
        "date": date,
        "postId": postId,
        "photoUrls": photoUrls,
        "isMale": isMale,
        "age": age,
        "reward": reward,
        "username": username,
        "dateTimePosted": dateTimePosted,
      };

  Map<String, dynamic> foundToJson() => {
        "type": type,
        "name": name,
        "location": location,
        "latitude": latitude,
        "longtitude": longtitude,
        "description": description,
        "date": date,
        "postId": postId,
        "photoUrls": photoUrls,
        "isMale": isMale,
        "username": username,
        "dateTimePosted": dateTimePosted,
        "breed" : breed,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      type: snapshot['type'],
      name: snapshot['name'],
      location: snapshot['location'],
      latitude: snapshot['latitude'],
      longtitude: snapshot['longtitude'],
      breed: snapshot['breed'],
      description: snapshot['description'],
      date: snapshot['date'],
      postId: snapshot['postId'],
      photoUrls: snapshot['photoUrls'],
      isMale: snapshot['isMale'],
      age: snapshot['age'],
      reward: snapshot['reward'],
      username: snapshot['username'],
      dateTimePosted: snapshot['dateTimePosted'],
    );
  }
}
