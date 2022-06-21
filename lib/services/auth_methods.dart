import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:find_my_pet_sg/models/user.dart' as model;
// import 'package:untitled/pages/welcome_page.dart';
import 'package:find_my_pet_sg/services/storage_methods.dart';

import '../utils/showSnackBar.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // FirebaseAuthMethods(this._auth);

  // get user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  // sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String displayName,
    required Uint8List file,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          displayName.isNotEmpty ||
          file != null) {
        // register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        // add user to our database

        model.User user = model.User(
          displayName: displayName,
          uid: cred.user!.uid,
          email: email,
          photoUrl: photoUrl,
        );

        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());

        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
// final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// GET USER DATA
// using null check operator since this method should be called only
// when the user is logged in
// User get user => _auth.currentUser!;

// GET PROFILE IMAGE
// getProfileImage() {
//   if (_auth.currentUser?.photoURL != null) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(100),
//       ),
//       child: Image.network(
//         _auth.currentUser!.photoURL!,
//         height: 100,
//         width: 100,
//       ),
//     );
//   } else {
//     return Icon(Icons.account_circle, size: 100);
//   }
// }

//STATE PERSISTENCE STREAM
// Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

// EMAIL SIGN UP
// Future<void> signUpWithEmail({
//   required String email,
//   required String password,
//   required String displayName,
//   required Uint8List file,
//   required BuildContext context,
// }) async {
//   try {
//     UserCredential cred = await _auth.createUserWithEmailAndPassword(
//         email: email, password: password);
//     await sendEmailVerification(context);
//
//     String photoUrl = await StorageMethods()
//         .uploadImageToStorage('profilePics', file, false);
//
//     //add user to database
//     model.User user = model.User(
//         uid: cred.user!.uid,
//         email: email,
//         displayName: displayName,
//         photoUrl: photoUrl);
//
//     await _firestore.collection('users').doc(cred.user!.uid).set(
//           user.toJson(),
//         );
//   } on FirebaseAuthException catch (e) {
//     showSnackBar(context, e.message!);
//   }

// EMAIL LOGIN
// Future<void> loginWithEmail({
//   required String email,
//   required String password,
//   required BuildContext context,
// }) async {
//   try {
//     await _auth.signInWithEmailAndPassword(email: email, password: password);
//     if (!_auth.currentUser!.emailVerified) {
//       await sendEmailVerification(context);
//       Navigator.pushNamed(context, WelcomePage.route);
//     }
//   } on FirebaseAuthException catch (e) {
//     showSnackBar(context, e.message!);
//   }
// }

// EMAIL VERIFICATION
// Future<void> sendEmailVerification(BuildContext context) async {
//   try {
//     _auth.currentUser!.sendEmailVerification();
//     showSnackBar(context, 'Email verification sent!');
//   } on FirebaseAuthException catch (e) {
//     showSnackBar(context, e.message!);
//   }
// }

// GOOGLE SIGN IN
//   Future<void> signInWithGoogle(BuildContext context) async {
//     try {
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//
//       final GoogleSignInAuthentication? googleAuth =
//           await googleUser?.authentication;
//
//       if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
//         // Create a new credential
//         final credential = GoogleAuthProvider.credential(
//           accessToken: googleAuth?.accessToken,
//           idToken: googleAuth?.idToken,
//         );
//         UserCredential userCredential =
//             await _auth.signInWithCredential(credential);
//       }
//     } on FirebaseAuthException catch (e) {
//       showSnackBar(context, e.message!);
//     }
//   }
//
//   // FACEBOOK SIGN IN
//   Future<void> signInWithFacebook(BuildContext context) async {
//     try {
//       final LoginResult loginResult = await FacebookAuth.instance.login();
//
//       final OAuthCredential facebookAuthCredential =
//           FacebookAuthProvider.credential(loginResult.accessToken!.token);
//
//       await _auth.signInWithCredential(facebookAuthCredential);
//     } on FirebaseAuthException catch (e) {
//       showSnackBar(context, e.message!); // Displaying the error message
//     }
//   }
//
// SIGN OUT
// Future<void> signOut(BuildContext context) async {
//   try {
//     await _auth.signOut();
//   } on FirebaseAuthException catch (e) {
//     showSnackBar(context, e.message!); // Displaying the error message
//   }
// }

// DELETE ACCOUNT
// Future<void> deleteAccount(BuildContext context) async {
//   try {
//     await _auth.currentUser!.delete();
//     Navigator.pushNamed(context, WelcomePage.route);
//   } on FirebaseAuthException catch (e) {
//     showSnackBar(context, e.message!); // Displaying the error message
//     // if an error of requires-recent-login is thrown, make sure to log
//     // in user again and then delete account.
//   }
// }
// }
