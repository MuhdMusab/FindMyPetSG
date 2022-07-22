import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:find_my_pet_sg/config/constants.dart';
import '../helper/google_sign_in_provider.dart';
import 'package:find_my_pet_sg/screens/edit_lost_post.dart';
import 'package:find_my_pet_sg/screens/settings_screen.dart';
import 'package:find_my_pet_sg/services/auth.dart';
import 'package:find_my_pet_sg/services/database.dart';
import 'package:find_my_pet_sg/services/notification_service.dart';
import 'package:find_my_pet_sg/services/storage_methods.dart';
import 'package:find_my_pet_sg/screens/main_page.dart';
import 'package:find_my_pet_sg/widgets/delete_post_dialog.dart';
import 'package:find_my_pet_sg/widgets/own_slider_carousel.dart';
import 'package:find_my_pet_sg/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:find_my_pet_sg/models/chatroom.dart';
import 'package:find_my_pet_sg/models/chatroomdao.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../widgets/lost_pet_post.dart';
import '../widgets/found_pet_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OwnLostPetPost extends StatefulWidget {
  final Map<String, dynamic> snapshot;
  final int postIndex;
  final String username;
  Function callback;
  final String postId;

  OwnLostPetPost({
    Key? key,
    required this.snapshot,
    required this.postIndex,
    required this.username,
    required this.callback,
    required this.postId,
  }) : super(key: key);

  @override
  State<OwnLostPetPost> createState() => _OwnLostPetPostState();
}

class _OwnLostPetPostState extends State<OwnLostPetPost> {
  deletePost() async {
    //delete post
    //delete storage files
    //user, access post index, delete post index, get last post index and shift
    //user, delete storageRefs, get last storage ref index and shift
    int numberOfImagesInPost = await DatabaseMethods.getNumberOfImagesInPost(
        widget.username, widget.postId);
    print('Number of images in post: $numberOfImagesInPost');
    final StorageMethods storageMethods = StorageMethods();
    for (int i = 0; i < numberOfImagesInPost; i++) {
      String prevRef = await DatabaseMethods.getStorageReferenceAtIndex(
          widget.username, widget.postIndex, i);
      storageMethods.deleteImageFromStorage(prevRef);
    }
    DatabaseMethods.deleteUserPostAtIndex(widget.username, widget.postIndex);
    DatabaseMethods.deleteStorageRefAtIndex(widget.username, widget.postIndex);
    DatabaseMethods.deleteUserPost(widget.username, widget.postId);
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8.0, bottom: 20.0, top: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(1),
                      spreadRadius: 0,
                      blurRadius: 20,
                      blurStyle: BlurStyle.outer,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    OwnSliderCarousel(
                        postIndex: widget.postIndex,
                        username: widget.username,
                        posts: widget.snapshot['photoUrls'],
                        callback: widget.callback,
                        postId: widget.snapshot['postId']),
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  widget.snapshot['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                widget.snapshot['isMale']
                                    ? Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            color: Colors.blue),
                                        child: Center(
                                          child: Icon(
                                            Icons.male,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            color: Colors.pink),
                                        child: Center(
                                          child: Icon(
                                            Icons.female,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  height: 24,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: lightPink().withOpacity(1),
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: Center(
                                    child: Text(
                                      'Lost',
                                      style: TextStyle(
                                        color:
                                            Color(0xFFFf5757), //ff5757 pink()
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                widget.snapshot['reward'] > 0
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        height: 24,
                                        width: 70,
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(8.0)),
                                        child: Center(
                                          child: Text(
                                            'Reward',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(),
                      ],
                    ),
                    Stack(children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, top: 5.0, bottom: 4.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Color(0xFFFf5757),
                              ),
                              Text(widget.snapshot['location']),
                            ],
                          ),
                        ),
                      ),
                      Row(),
                    ]),
                    Stack(children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: Color(0xFFFf5757),
                            ),
                            Text(widget.snapshot['date']),
                          ],
                        ),
                      ),
                      Row(),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          child: InkWell(
            customBorder: CircleBorder(),
            onTap: () {
              print(widget.postIndex.toString() + 'hellooo');
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DeletePostDialog(
                      function: deletePost,
                    );
                  });
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                Icons.delete,
                color: Colors.blueGrey,
                shadows: [Shadow(offset: Offset(1, 0), blurRadius: 1)],
                size: 32,
              ),
            ),
          ),
          right: 20,
          bottom: 18,
        ),
        Positioned(
          child: InkWell(
            customBorder: CircleBorder(),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditLostPostScreen(
                      snapshot: widget.snapshot,
                      postIndex: widget.postIndex,
                      postId: widget.postId,
                      username: widget.username,
                      callback: widget.callback,
                    ),
                  ));
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                Icons.edit,
                shadows: [Shadow(offset: Offset(1, 0), blurRadius: 1)],
                color: Colors.blueGrey,
                size: 32,
              ),
            ),
          ),
          right: 60,
          bottom: 18,
        ),
      ],
    );
  }
}
