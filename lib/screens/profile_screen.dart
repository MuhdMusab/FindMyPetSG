import 'dart:async';
import 'dart:math';
import 'package:find_my_pet_sg/config/constants.dart';

import 'package:file_picker/file_picker.dart';
import 'package:find_my_pet_sg/screens/main_page.dart';
import 'package:find_my_pet_sg/screens/settings_screen.dart';
import 'package:find_my_pet_sg/services/database.dart';
import 'package:find_my_pet_sg/services/storage_methods.dart';
import 'package:find_my_pet_sg/widgets/own_lost_pet_post.dart';
import 'package:find_my_pet_sg/widgets/own_found_pet_post.dart';
import 'package:find_my_pet_sg/widgets/profile_picture_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timezone/data/latest.dart' as tz;

class ProfileScreen extends StatefulWidget {
  QueryDocumentSnapshot<Object?>? _user;

  ProfileScreen(QueryDocumentSnapshot<Object?>? user) {
    this._user = user;
  }

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin<ProfileScreen> {
  @override
  bool get wantKeepAlive => true;
  StreamSubscription<DocumentSnapshot>? subscription;
  List<DocumentSnapshot>? myList;
  TextEditingController userNameTextEditingController = TextEditingController();
  int? _userIndex;
  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    // _activateListeners();
  }



  _getNumberOfPosts(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    final int totalNumberOfPosts = snapshot.data!.docs.length;
    int numberOfPosts = 0;
    final String username = widget._user!['name'].toString();
    for (int i = 0; i < totalNumberOfPosts; i++) {
      if (snapshot.data!.docs[i].data()['username'] == username) {
        numberOfPosts++;
      }
    }
    return numberOfPosts;
  }

  _callback() {
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final String username = widget._user!['name'].toString();
    final StorageMethods storage = StorageMethods(username: username);
    int postIndex = 0;
    // _callback() {
    //   setState(() {
    //   });
    // }
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            // int count = 0;
            // for (int i = 0; i < snapshot.data!.docs.length; i++) {
            //   if (snapshot.data!.docs[i].data()['username'] == username) {
            //     count++;
            //   }
            // }
            postIndex = 0;
            if (snapshot.connectionState == ConnectionState.done || snapshot.hasData) {
              return Column(
                children: [
                  SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            color: pink(),
                            onPressed: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                    const SettingsScreen(),
                                  ))
                            },
                            icon: const Icon(Icons.settings)),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        ClipOval(
                          child: Material(
                            color: Colors.transparent,
                            child: ProfilePictureWidget(callback: _callback, storage: storage, username: username,),
                          ),
                        ),
                        Positioned(
                          bottom: 1,
                          right: 2,
                          child: ClipOval(
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              color: Colors.white,
                              child: ClipOval(
                                child: Container(
                                  padding: const EdgeInsets.all(7),
                                  color: Colors.blue,
                                  child: const Icon(
                                    Icons.edit,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Hello, " + widget._user!['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Your posts (" +
                            _getNumberOfPosts(snapshot).toString() +
                            ")",
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    height: 1,
                    thickness: 2,
                    color: Colors.white,
                  ),
                  Expanded(
                      child: ListView.builder(
                        itemBuilder: (ctx, index) {
                          return index < snapshot.data!.docs.length &&
                              snapshot.data!.docs[index].data()['username'] ==
                                  username
                              ? snapshot.data!.docs[index].data()['type'] == 'lost'
                              ? OwnLostPetPost(
                            snapshot: snapshot.data!.docs[index].data(),
                            postIndex: postIndex++,
                            username: username,
                            callback: _callback,
                            postId:
                            snapshot.data!.docs[index].data()['postId'],
                          )
                              : OwnFoundPetPost(
                            snapshot: snapshot.data!.docs[index].data(),
                            postIndex: postIndex++,
                            username: username,
                            callback: _callback,
                            postId:
                            snapshot.data!.docs[index].data()['postId'],
                          )
                              : Container();
                        },
                        itemCount: snapshot.data!.docs.length,
                      )),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator(color: Colors.black,));
            }
          }),
    );
  }
}
