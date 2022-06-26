import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
// import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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

  // Future<void> deleteImageFromStorage(String childName,) async {
  //   Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);
  //   ListResult temp = await ref.listAll();
  //   for (Reference refs in temp.items) {
  //     print(refs);
  //   }
  //   temp.items[0].delete().onError((error, stackTrace) => print('yes'));
  // }
}