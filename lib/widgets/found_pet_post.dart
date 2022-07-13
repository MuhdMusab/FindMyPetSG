
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_pet_sg/services/storage_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:find_my_pet_sg/widgets/arrow_back_button_2.dart';
import 'package:find_my_pet_sg/widgets/image_slider_carousel.dart';
import 'package:find_my_pet_sg/widgets/noncurved_image_slider_carousel.dart';
import 'package:find_my_pet_sg/modal/chatroom.dart';
import 'package:find_my_pet_sg/modal/chatroomdao.dart';
import 'package:find_my_pet_sg/modal/messagedao.dart';
import 'package:find_my_pet_sg/screens/chat_screen.dart';

import 'arrow_back_button_3.dart';

class FoundPetPost extends StatefulWidget {
  final snap;
  final QueryDocumentSnapshot<Object?>? user;

  const FoundPetPost({
    Key? key,
    required this.snap,
    required this.user,
  }) : super(key: key);

  @override
  State<FoundPetPost> createState() => _FoundPetPostState();
}

class _FoundPetPostState extends State<FoundPetPost> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 20.0,),
      child: Material(
        child: InkWell(
          customBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          splashColor: Colors.black38,
          onTap: () => {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        FullFoundPetPost(foundPetPost: widget)))
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
                            widget.snap['name'] == '' ?
                            Container() :
                            Text(
                              widget.snap['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                              height: 24,
                              width: 70,
                              decoration: BoxDecoration(
                                  color: const Color(0xFFffc4d4).withOpacity(1),
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: const Center(
                                child: const Text(
                                  'Found',
                                  style: TextStyle(
                                    color: Color(
                                        0xFFFf5757), //ff5757 Color(0xFFf26579)
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
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
                    padding:
                    const EdgeInsets.only(left: 8.0, top: 5.0, bottom: 4.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
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
                        const Icon(
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

class FullFoundPetPost extends StatefulWidget {
  final FoundPetPost foundPetPost;
  const FullFoundPetPost({
    Key? key,
    required this.foundPetPost,
  }) : super(key: key);
  @override
  State<FullFoundPetPost> createState() => _FullFoundPetPostState();
}

class _FullFoundPetPostState extends State<FullFoundPetPost> {
  // deletePost(String postId) async {
  //   try {
  //     await FireStoreMethods().deletePost(postId);
  //   } catch (err) {
  //     showSnackBar(
  //       context,
  //       err.toString(),
  //     );
  //   }
  // }
  late GoogleMapController _googleMapController;

  void _showLocation() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return Scaffold(
          body: Stack(
            children: [
              GoogleMap(

                mapToolbarEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    widget.foundPetPost.snap['latitude'],
                    widget.foundPetPost.snap['longtitude'],
                  ),
                  zoom: 16,
                ),
                markers: {
                  Marker(
                      markerId: const MarkerId("lostLocation"),
                      position: LatLng(
                        widget.foundPetPost.snap['latitude'],
                        widget.foundPetPost.snap['longtitude'],
                      ))
                },
                onMapCreated: (controller) => _googleMapController = controller,
                zoomControlsEnabled: false,
                zoomGesturesEnabled: true,
              ),
              const Positioned(top: 50, left: 4, child: const ArrowBackButton3()),
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
                            widget.foundPetPost.snap['latitude'],
                            widget.foundPetPost.snap['longtitude'],
                          ),
                          zoom: 16,
                        )))),
              ),
            ],
          ),
        );
      }),
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
                    imageArray: widget.foundPetPost.snap['photoUrls']),
                const Padding(
                  padding: EdgeInsets.only(top: 12.0, left: 8),
                  child: ArrowBackButton2(),
                ),
              ]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                  child: widget.foundPetPost.snap['name'] == '' ?
                  Container() :
                  Text(
                    widget.foundPetPost.snap['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20,
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
                        Text("Location: " + widget.foundPetPost.snap['location']),
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
                  Text("Breed: " + widget.foundPetPost.snap['breed']),
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
                child: Text(widget.foundPetPost.snap['description'],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.robotoCondensed()),
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
                        widget.foundPetPost.snap['date'],
                        style: const TextStyle(
                          color: Colors.black45,
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [],
                )
              ],
            ),
            const Divider(
              color: Colors.black,
            ),
            InkWell(
              customBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
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
                          const Padding(
                            padding: EdgeInsets.only(right: 10.0, top: 2.0),
                            child: Icon(MdiIcons.mapMarker, color: Colors.pink),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            widget.foundPetPost.user!['name'].toString() == widget.foundPetPost.snap['username']
                ? Container()
                : InkWell(
              customBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              onTap: () async {
                final ownUsername =
                widget.foundPetPost.user!['name'].toString();
                final otherUsername = widget.foundPetPost.snap['username'];
                final messageDao = MessageDao(ownUsername, otherUsername);
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
                      messageDao: MessageDao(ownUsername, otherUsername),
                      circleAvatar: _circleAvatar,
                    ),
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
                      messageDao: MessageDao(ownUsername, otherUsername),
                      circleAvatar: _circleAvatar,
                    ),
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
                  child: Stack(
                    children: [
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
                          const Padding(
                            padding:
                            EdgeInsets.only(right: 10.0, top: 2.0),
                            child: const Icon(MdiIcons.message, color: Colors.pink),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
