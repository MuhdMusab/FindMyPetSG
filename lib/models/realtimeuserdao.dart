import 'package:firebase_database/firebase_database.dart';
import 'package:find_my_pet_sg/models/RealtimeUser.dart';

class RealtimeUserDao {
  final DatabaseReference _realtimeUserRef =
  FirebaseDatabase(databaseURL: 'https://findmypetsg-default-rtdb.asia-southeast1.firebasedatabase.app')
      .ref().child('users');

  void saveUser(RealtimeUser user) {
    _realtimeUserRef.push().set(user.toJson());
  }

  Query getUserQuery() {
    return _realtimeUserRef;
  }

}