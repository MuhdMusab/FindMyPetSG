import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:find_my_pet_sg/widgets/arrow_back_button_2.dart';
import 'package:find_my_pet_sg/widgets/image_slider_carousel.dart';
import 'package:find_my_pet_sg/widgets/noncurved_image_slider_carousel.dart';
import 'package:find_my_pet_sg/models/user.dart' as model;
import '../providers/user_provider.dart';
import '../services/firestore_methods.dart';
import '../utils/showSnackBar.dart';

class LostPetPost extends StatefulWidget {
  final snap;
  // final String name;
  // final String postalCode;
  // final String description;
  // final String location;
  // final String type; // cat dog bird others
  // final String date;
  // final String exactLocation;
  // final bool isMale;
  // final int reward;
  // final imageArray;

  const LostPetPost({
    Key? key,
    required this.snap,
    // required this.location,
    // required this.date,
    // required this.name,
    // required this.imageArray,
    // required this.reward,
    // required this.postalCode,
    // required this.description,
    // required this.type,
    // required this.exactLocation,
    // required this.isMale,
  }) : super(key: key);

  @override
  State<LostPetPost> createState() => _LostPetPostState();
}

class _LostPetPostState extends State<LostPetPost> {
  @override
  Widget build(BuildContext context) {
    // final model.User user = Provider.of<UserProvider>(context).getUser;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 20.0),
      child: Material(
        child: InkWell(
          customBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          splashColor: Colors.black38,
          onTap: () => {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FullLostPetPost(lostPetPost: widget)))
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
                  imageArray: [widget.snap['photoUrl']],
                ),
                Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Text(
                            widget.snap['date'],
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Text(
                              widget.snap['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.pink,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          // widget.isMale
                          true
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
                        ],
                      ),
                    ),
                  ],
                ),
                Stack(children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, top: 5.0, bottom: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(widget.snap['location']),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      true
                          // widget.reward > 0
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  right: 4.0, bottom: 4.0),
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  height: 24,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: Center(
                                      // child: Text(
                                      //   '\$' + widget.reward.toString(),
                                      //   style: TextStyle(
                                      //     color: Colors.white,
                                      //     fontSize: 18,
                                      //   ),
                                      // ),
                                      )),
                            )
                          : Container(),
                    ],
                  )
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: Stack(children: [
              NonCurvedImageSliderCarousel(
                  imageArray: [widget.lostPetPost.snap['photoUrl']]),
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
                    color: Colors.pink,
                    fontSize: 20,
                  ),
                ),
              ),
              // widget.lostPetPost.isMale
              true
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(widget.lostPetPost.snap['location']),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 20),
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
                  // widget.lostPetPost.reward > 0
                  true
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
                                  // child: Text(
                                  //   '\$' + widget.lostPetPost.reward.toString(),
                                  //   style: TextStyle(
                                  //     color: Colors.white,
                                  //     fontSize: 18,
                                  //   ),
                                  // ),
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
            customBorder:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            onTap: () {},
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
                          padding: const EdgeInsets.only(right: 10.0, top: 2.0),
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
          InkWell(
            customBorder:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            onTap: () {},
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
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0, top: 2.0),
                          child: Icon(MdiIcons.message, color: Colors.pink),
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
    );
  }
}
