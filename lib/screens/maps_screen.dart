import 'dart:async';
// import 'dart:ffi';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_pet_sg/config/constants.dart';
import 'package:find_my_pet_sg/helper/functions.dart';
import 'package:find_my_pet_sg/utils/showSnackBar.dart';
import 'package:find_my_pet_sg/widgets/arrow_back_button_3.dart';
import 'package:find_my_pet_sg/widgets/found_pet_post.dart';
import 'package:find_my_pet_sg/widgets/image_slider_carousel.dart';
import 'package:find_my_pet_sg/widgets/lost_pet_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:intl/intl.dart';

import '../map_markers/map_markers.dart';
import '../models/category.dart';
import '../models/filter_model.dart';
import '../models/post_type_model.dart';

class MapsScreen extends StatefulWidget {
  List<Filter?> filters;
  QueryDocumentSnapshot<Object?>? user;
  LatLng initialLatLng;
  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot;
  MapsScreen({
    Key? key,
    required this.user,
    required this.initialLatLng,
    required this.filters,
    required this.snapshot,
  }) : super(key: key);

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen>
    with AutomaticKeepAliveClientMixin<MapsScreen> {
  late GoogleMapController _googleMapController;
  @override
  bool get wantKeepAlive => true;
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  BitmapDescriptor findCorrectMarkerIcon(
      String lostPetPostType, String breed, String dateOfLostPet) {
    DateTime lostDate = DateFormat('d/M/y').parse(dateOfLostPet);
    bool isLostRecently = DateTime.now().difference(lostDate).inDays <= 3;
    if (lostPetPostType == "lost") {
      if (breed == "Dog") {
        return isLostRecently ? lookoutDogMarker! : lostDogMarker!;
      } else if (breed == "Cat") {
        return isLostRecently ? lookoutCatMarker! : lostCatMarker!;
      } else if (breed == "Bird") {
        return isLostRecently ? lookoutBirdMarker! : lostBirdMarker!;
      } else {
        return isLostRecently ? lookoutOthersMarker! : lostOthersMarker!;
      }
    } else {
      if (breed == "Dog") {
        return foundDogMarker!;
      } else if (breed == "Cat") {
        return foundCatMarker!;
      } else if (breed == "Bird") {
        return foundBirdMarker!;
      } else {
        return foundOthersMarker!;
      }
    }
    return foundCatMarker!;
  }

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
    for (int index = 0; index < numberOfPosts; index++) {
      bool postTypeBool = true;
      bool categoryBool = true;
      String lostPetBreed = snapshot.data!.docs[index].data()['breed'];
      String lostPetPostType = snapshot.data!.docs[index].data()['type'];
      if (widget.filters.isNotEmpty) {
        postTypeBool = false;
        categoryBool = false;
        for (int i = 0; i < 16; i++) {
          Filter filter = widget.filters[i]!;
          if (filter.value) {
            if (filter is Category) {
              categoryBool =
                  categoryBool || lostPetBreed == (filter as Category).name;
            } else {
              postTypeBool = postTypeBool ||
                  lostPetPostType == (filter as PostType).postType;
            }
          }
        }
      }
      if (postTypeBool && categoryBool) {
        print("accepted");
        if (lostPetPostType == "lost") {
          markers.add(Marker(
              icon: findCorrectMarkerIcon(lostPetPostType, lostPetBreed,
                  snapshot.data!.docs[index].data()['date']),
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
              icon: findCorrectMarkerIcon(lostPetPostType, lostPetBreed,
                  snapshot.data!.docs[index].data()['date']),
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
    super.build(context);
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
            _customInfoWindowController.googleMapController = controller;
            _googleMapController = controller;
          },
          mapToolbarEnabled: false,
          initialCameraPosition: CameraPosition(
            target: widget.initialLatLng,
            zoom: 16,
          ),
          markers: buildMarkers(widget.snapshot),
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
  }
}
