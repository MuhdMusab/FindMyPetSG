import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_pet_sg/config/constants.dart';
import 'package:find_my_pet_sg/helper/functions.dart';
import 'package:find_my_pet_sg/utils/showSnackBar.dart';
import 'package:find_my_pet_sg/widgets/arrow_back_button_3.dart';
import 'package:find_my_pet_sg/widgets/found_pet_post.dart';
import 'package:find_my_pet_sg/widgets/image_slider_carousel.dart';
import 'package:find_my_pet_sg/widgets/lost_pet_post.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:google_maps_webservice/geocoding.dart';

import '../models/category.dart';
import '../models/filter_model.dart';
import '../models/post_type_model.dart';

class MapsScreen extends StatefulWidget {
  List<Filter?> filters;
  QueryDocumentSnapshot<Object?>? user;
  LatLng initialLatLng;
  MapsScreen({
    Key? key,
    required this.user,
    required this.initialLatLng,
    required this.filters,
  }) : super(key: key);

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late GoogleMapController _googleMapController;
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  @override
  void dispose() {
    super.dispose();
    _googleMapController.dispose();
    _customInfoWindowController.dispose();
  }

  void initState() {
    super.initState();
    // this should not be done in build method.
  }

  Set<Marker> buildMarkers(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    int numberOfPosts = snapshot.data!.docs.length;
    Set<Marker> markers = {};
    BitmapDescriptor lostBitmapDescriptor =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose);
    BitmapDescriptor foundBitmapDescriptor = BitmapDescriptor.defaultMarker;
    for (int index = 0; index < numberOfPosts; index++) {
      bool postTypeBool = true;
      bool categoryBool = true;
      if (widget.filters.isNotEmpty) {
        postTypeBool = false;
        categoryBool = false;
        for (int i = 0; i < 16; i++) {
          Filter filter = widget.filters[i]!;
          if (filter.value) {
            if (filter is Category) {
              categoryBool = categoryBool ||
                  snapshot.data!.docs[index].data()['breed'] ==
                      (filter as Category).name;
            } else {
              postTypeBool = postTypeBool ||
                  snapshot.data!.docs[index].data()['type'] ==
                      (filter as PostType).postType;
            }
          }
        }
      }
      if (postTypeBool && categoryBool) {
        print("accepted");
        if (snapshot.data!.docs[index].data()['type'] == "lost") {
          markers.add(Marker(
              icon: lostBitmapDescriptor,
              markerId: MarkerId(snapshot.data!.docs[index].data()['postId']),
              position: LatLng(snapshot.data!.docs[index].data()['latitude'],
                  snapshot.data!.docs[index].data()['longtitude']),
              onTap: () {
                _customInfoWindowController.addInfoWindow!(
                    LostPetPost(
                      snap: snapshot.data!.docs[index].data(),
                      user: widget.user,
                    ),
                    LatLng(snapshot.data!.docs[index].data()['latitude'],
                        snapshot.data!.docs[index].data()['longtitude']));
              }));
        } else {
          markers.add(Marker(
              icon: foundBitmapDescriptor,
              markerId: MarkerId(snapshot.data!.docs[index].data()['postId']),
              position: LatLng(snapshot.data!.docs[index].data()['latitude'],
                  snapshot.data!.docs[index].data()['longtitude']),
              onTap: () {
                _customInfoWindowController.addInfoWindow!(
                    FoundPetPost(
                      snap: snapshot.data!.docs[index].data(),
                      user: widget.user,
                    ),
                    LatLng(snapshot.data!.docs[index].data()['latitude'],
                        snapshot.data!.docs[index].data()['longtitude']));
              }));
        }
      }
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .orderBy("dateTimePosted", descending: true)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Stack(
              children: [
                GoogleMap(
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  onTap: (position) {
                    _customInfoWindowController.hideInfoWindow!();
                  },
                  onCameraMove: (position) {
                    _customInfoWindowController.onCameraMove!();
                  },
                  onMapCreated: (GoogleMapController controller) async {
                    _customInfoWindowController.googleMapController =
                        controller;
                    _googleMapController = controller;
                  },
                  mapToolbarEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: widget.initialLatLng,
                    zoom: 16,
                  ),
                  markers: buildMarkers(snapshot),
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: true,
                ),
                // Positioned(
                //   right: 16,
                //   bottom: 80,
                //   child: FloatingActionButton(
                //       child: const Icon(
                //         Icons.center_focus_strong,
                //         size: 30.0,
                //         color: Colors.white,
                //       ),
                //       backgroundColor: pink(),
                //       heroTag: getRandomString(),
                //       onPressed: () {
                //         _googleMapController.animateCamera(
                //             CameraUpdate.newCameraPosition(CameraPosition(
                //                 target: widget.currentLatLng, zoom: 16)));
                //       }),
                // ),
                CustomInfoWindow(
                  controller: _customInfoWindowController,
                  offset: 0,
                  width: MediaQuery.of(context).size.width - 50,
                  height: 330,
                ),
              ],
            );
          }),
    );
  }
}
