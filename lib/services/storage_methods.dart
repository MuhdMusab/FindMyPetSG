import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'dart:io';

class StorageMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String? _username;

  StorageMethods({String? username}) : _username = username;

  // adding image to firebase storage
  Future<List<String>> uploadImageToStorage(
      String childName, Uint8List file,) async {
    // creating location to our firebase storage

    Reference ref =
    _storage.ref().child(childName).child(_auth.currentUser!.uid);
    String id = const Uuid().v1();
    ref = ref.child(id);

    // putting in uint8list format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return [downloadUrl, id];
  }

  Future<void> deleteImageFromStorage(String childName,) async {
    Reference ref = _storage.ref().child('posts').child(_auth.currentUser!.uid).child(childName);
    ref.delete();
  }



  Future<void> uploadFile(String filePath,
      String fileName,) async {
    File file = File(filePath);

    try {
      await _storage.ref('profile pics/$_username/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult results = await _storage.ref(
        'profile pics/$_username').listAll();
    results.items.forEach((firebase_storage.Reference ref) {
      print('Found file: $ref');
    });
    return results;
  }

  Future<String> downloadURL() async {
    return await _storage.ref(
        'profile pics/$_username/$_username' + '_profile_picture')
        .getDownloadURL();
  }
}