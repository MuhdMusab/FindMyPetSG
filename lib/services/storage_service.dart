import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'dart:io';

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  String? _username;

  Storage(String username) {
    this._username = username;
  }

  Future<void> uploadFile(
        String filePath,
        String fileName,
      ) async {
      File file = File(filePath);

      try {
        await storage.ref('profile pics/$_username/$fileName').putFile(file);
      } on firebase_core.FirebaseException catch (e) {
        print(e);
      }
  }

  Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult results = await storage.ref('profile pics/$_username').listAll();
    results.items.forEach((firebase_storage.Reference ref) {
      print('Found file: $ref');
    });
    return results;
  }

  Future<String> downloadURL() async {
    return await storage.ref('profile pics/$_username/$_username' + '_profile_picture').getDownloadURL();
  }
}