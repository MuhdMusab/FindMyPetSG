import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_pet_sg/services/database.dart';
import 'package:find_my_pet_sg/services/storage_methods.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> uploadLostPost(
      String type,
      String description,
      List<File> files,
      String name,
      String location,
      double latitude,
      double longtitude,
      String breed,
      String date,
      int reward,
      int age,
      bool isMale,
      String username,
      DateTime dateTimePosted,
      ) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      List<String> photoUrls = [];
      int postLength = await DatabaseMethods.getPostsLength(username);
      int storageRefsLength =
      await DatabaseMethods.getStorageReferenceLength(username);
      for (File file in files) {
        List<String> urls = await StorageMethods().uploadImageToStorage(
          'posts',
          file.readAsBytesSync(),
        );
        await DatabaseMethods.addPost(username, urls[0], postLength);
        await DatabaseMethods.addStorageReference(
            username, urls[1], storageRefsLength);
        photoUrls.add(urls[0]);
      }

      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
        type: type,
        description: description,
        name: name,
        date: date,
        location: location,
        latitude: latitude,
        longtitude: longtitude,
        breed: breed,
        postId: postId,
        photoUrls: photoUrls,
        reward: reward,
        age: age,
        isMale: isMale,
        username: username,
        dateTimePosted: dateTimePosted,
      );
      _firestore.collection('posts').doc(postId).set(post.lostToJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> uploadFoundPost(
      String type,
      String description,
      List<File> files,
      String location,
      double latitude,
      double longtitude,
      String date,
      String username,
      DateTime dateTimePosted,
      String breed,
      String name,
      ) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      List<String> photoUrls = [];
      int postLength = await DatabaseMethods.getPostsLength(username);
      int storageRefsLength =
      await DatabaseMethods.getStorageReferenceLength(username);
      for (File file in files) {
        List<String> urls = await StorageMethods().uploadImageToStorage(
          'posts',
          file.readAsBytesSync(),
        );
        await DatabaseMethods.addPost(username, urls[0], postLength);
        await DatabaseMethods.addStorageReference(
            username, urls[1], storageRefsLength);
        photoUrls.add(urls[0]);
      }

      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
          type: type,
          description: description,
          name: name,
          date: date,
          location: location,
          latitude: latitude,
          longtitude: longtitude,
          postId: postId,
          photoUrls: photoUrls,
          isMale: false,
          username: username,
          dateTimePosted: dateTimePosted,
          breed: breed,
      );
      _firestore.collection('posts').doc(postId).set(post.foundToJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
