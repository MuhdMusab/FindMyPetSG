import "package:firebase_auth/firebase_auth.dart";
import "package:find_my_pet_sg/modal/person.dart";

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Person ? _userFromFireBaseUser(User user) {
    return user != null ? Person(userId: user.uid) : null;
  }
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword
        (email: email, password: password);
      User firebaseUser = result.user!;
      return _userFromFireBaseUser(firebaseUser);
    } catch (e){
      print(e.toString());
      return null;
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword
        (email: email, password: password);
      User ? firebaseUser = result.user;
      return _userFromFireBaseUser(firebaseUser!);
    } catch (e){
      print(e.toString());
      return null;
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
