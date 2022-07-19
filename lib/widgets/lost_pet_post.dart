import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_pet_sg/config/constants.dart';
import 'package:find_my_pet_sg/services/storage_methods.dart';
import '../helper/custom_icons_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:find_my_pet_sg/widgets/arrow_back_button_2.dart';
import 'package:find_my_pet_sg/widgets/image_slider_carousel.dart';
import 'package:find_my_pet_sg/widgets/noncurved_image_slider_carousel.dart';
import 'package:find_my_pet_sg/models/user.dart' as model;
import '../services/firestore_methods.dart';
import '../utils/showSnackBar.dart';
import 'package:find_my_pet_sg/modal/chatroom.dart';
import 'package:find_my_pet_sg/modal/chatroomdao.dart';
import 'package:find_my_pet_sg/modal/messagedao.dart';
import 'package:find_my_pet_sg/screens/chat_screen.dart';

import 'arrow_back_button.dart';
import 'arrow_back_button_3.dart';

class LostPetPost extends StatefulWidget {
  final snap;
  final QueryDocumentSnapshot<Object?>? user;

  const LostPetPost({
    Key? key,
    required this.snap,
    required this.user,
  }) : super(key: key);

  @override
  State<LostPetPost> createState() => _LostPetPostState();
}

class _LostPetPostState extends State<LostPetPost> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: 20.0,
      ),
      child: Material(
        child: InkWell(
          customBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          splashColor: Colors.black38,
          onTap: () => {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FullLostPetPost(lostPetPost: widget),
                    fullscreenDialog: true))
          },
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
                ImageSliderCarousel(
                  imageArray: widget.snap['photoUrls'],
                ),
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
                              widget.snap['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            widget.snap['isMale']
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              height: 24,
                              width: 70,
                              decoration: BoxDecoration(
                                  color: lightPink(),
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: Center(
                                child: Text(
                                  'Lost',
                                  style: TextStyle(
                                    color: Color(
                                        0xFFFf5757), //ff5757 pink()
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            widget.snap['reward'] > 0
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
                          ],
                        ),
                      ),
                    ),
                    Row(),
                  ],
                ),
                Stack(children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, top: 5.0, bottom: 4.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Color(0xFFFf5757),
                          ),
                          Text(widget.snap['location']),
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
                        Text(widget.snap['date']),
                      ],
                    ),
                  ),
                  Row(),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FullLostPetPost extends StatefulWidget {
  final LostPetPost lostPetPost;
  const FullLostPetPost({
    Key? key,
    required this.lostPetPost,
  }) : super(key: key);
  @override
  State<FullLostPetPost> createState() => _FullLostPetPostState();
}

class _FullLostPetPostState extends State<FullLostPetPost> {
  late GoogleMapController _googleMapController;

  void _showLocation() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) {
            return Scaffold(
              body: Stack(
                children: [
                  GoogleMap(
                    mapToolbarEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        widget.lostPetPost.snap['latitude'],
                        widget.lostPetPost.snap['longtitude'],
                      ),
                      zoom: 16,
                    ),
                    markers: {
                      Marker(
                          markerId: const MarkerId("lostLocation"),
                          position: LatLng(
                            widget.lostPetPost.snap['latitude'],
                            widget.lostPetPost.snap['longtitude'],
                          ))
                    },
                    onMapCreated: (controller) =>
                        _googleMapController = controller,
                    zoomControlsEnabled: false,
                    zoomGesturesEnabled: true,
                  ),
                  Positioned(top: 50, left: 4, child: ArrowBackButton3()),
                  Positioned(
                    right: 10,
                    bottom: 80,
                    child: FloatingActionButton(
                        child: const Icon(
                          Icons.center_focus_strong,
                          color: Colors.white,
                        ),
                        backgroundColor: Colors.pink,
                        onPressed: () => _googleMapController.animateCamera(
                                CameraUpdate.newCameraPosition(CameraPosition(
                              target: LatLng(
                                widget.lostPetPost.snap['latitude'],
                                widget.lostPetPost.snap['longtitude'],
                              ),
                              zoom: 16,
                            )))),
                  ),
                ],
              ),
            );
          },
          fullscreenDialog: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              child: Stack(children: [
                NonCurvedImageSliderCarousel(
                    imageArray: widget.lostPetPost.snap['photoUrls']),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, left: 8),
                  child: ArrowBackButton2(),
                ),
              ]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                  child: Text(
                    widget.lostPetPost.snap['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
                widget.lostPetPost.snap['isMale']
                    ? Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
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
                            borderRadius: BorderRadius.circular(100.0),
                            color: Colors.pink),
                        child: Center(
                          child: Icon(
                            Icons.female,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 5.0, bottom: 4.0),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                            "Location: " + widget.lostPetPost.snap['location']),
                      ],
                    ),
                  ),
                  Row(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 5.0, bottom: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Age: " + widget.lostPetPost.snap['age'].toString()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 5.0, bottom: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Breed: " + widget.lostPetPost.snap['breed']),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 5.0, bottom: 4.0),
              child: Row(
                children: [
                  Text(
                    "Description",
                    style: GoogleFonts.roboto(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8.0, top: 4, bottom: 20),
              child: Container(
                child: Text(widget.lostPetPost.snap['description'],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.robotoCondensed(

                    )),
              ),
            ),
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Text(
                        widget.lostPetPost.snap['date'],
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    widget.lostPetPost.snap['reward'] > 0
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 4.0, bottom: 4.0),
                            child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 4.0),
                                height: 24,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: Center(
                                  child: Text(
                                    '\$' +
                                        widget.lostPetPost.snap['reward']
                                            .toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                )),
                          )
                        : Container(),
                  ],
                )
              ],
            ),
            Divider(
              color: Colors.black,
            ),
            InkWell(
              customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              onTap: _showLocation,
              splashColor: Colors.black12,
              child: Container(
                width: 300,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(6.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 0,
                      blurRadius: 6,
                      blurStyle: BlurStyle.outer,
                    )
                  ],
                ),
                child: Center(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "View on map",
                              style: GoogleFonts.openSans(
                                  color: Colors.pink, fontSize: 18),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 10.0, top: 2.0),
                            child: Icon(MdiIcons.mapMarker, color: Colors.pink),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            widget.lostPetPost.user!['name'].toString() ==
                    widget.lostPetPost.snap['username']
                ? Container()
                : InkWell(
                    customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
              onTap: () async {
                final ownUsername =
                widget.lostPetPost.user!['name'].toString();
                final otherUsername =
                widget.lostPetPost.snap['username'];
                final messageDao =
                MessageDao(ownUsername, otherUsername);
                if (ownUsername == otherUsername) {
                  //do nothing
                } else if ((await messageDao.getOwnChatQuery().get())
                    .exists) {
                  final StorageMethods storage = StorageMethods(username: otherUsername);
                  String url = await storage.downloadURL();
                  CircleAvatar _circleAvatar = url == 'fail'
                      ? CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage("assets/images/default_user_icon.png"),
                  )
                      : CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(url),
                  );
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      username: otherUsername,
                      messageDao:
                      MessageDao(ownUsername, otherUsername),
                      circleAvatar: _circleAvatar,
                    ),
                    fullscreenDialog: true,
                  ));
                } else {
                  final chatroomDao = ChatroomDao();
                  chatroomDao.addChatroom(
                      ownUsername, Chatroom(otherUsername));
                  chatroomDao.addChatroom(
                      otherUsername, Chatroom(ownUsername));
                  messageDao.getOwnChatQuery().ref.set("");
                  messageDao.getOtherChatQuery().ref.set("");
                  final StorageMethods storage = StorageMethods(username: otherUsername);
                  String url = await storage.downloadURL();
                  CircleAvatar _circleAvatar = url == 'fail'
                      ? CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage("assets/images/default_user_icon.png"),
                  )
                      : CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(url),
                  );
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      username: otherUsername,
                      messageDao:
                      MessageDao(ownUsername, otherUsername),
                      circleAvatar: _circleAvatar,
                    ),
                    fullscreenDialog: true,
                  ));
                }
              },
                    splashColor: Colors.black12,
                    child: Container(
                      width: 300,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(6.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 0,
                            blurRadius: 6,
                            blurStyle: BlurStyle.outer,
                          )
                        ],
                      ),
                      child: Center(
                        child: Stack(children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Message",
                                  style: GoogleFonts.openSans(
                                      color: Colors.pink, fontSize: 18),
                                )
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 10.0, top: 2.0),
                                child: Icon(MdiIcons.message,
                                    color: Colors.pink),
                              )
                            ],
                          )
                        ]),
                      ),
                    ),
                  ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
