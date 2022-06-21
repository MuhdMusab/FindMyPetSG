import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String displayName;
  final String photoUrl;
  const User({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.photoUrl,
  });

  Map<String, dynamic> toJson() => {
        "displayName": displayName,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      displayName: snapshot['displayName'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      photoUrl: snapshot['photoUrl'],
    );
  }
}
