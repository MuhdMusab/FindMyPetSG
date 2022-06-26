import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String name;
  final List<String> posts;

  const User({
    required this.email,
    required this.name,
    required this.posts,
  });

  Map<String, dynamic> toJson() => {
    "email": email,
    "name": name,
  };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      email: snapshot['email'],
      name: snapshot['name'],
      posts: snapshot['posts'],
    );
  }
}