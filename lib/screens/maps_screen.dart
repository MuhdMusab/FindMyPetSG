import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_pet_sg/widgets/arrow_back_button_3.dart';
import 'package:find_my_pet_sg/widgets/found_pet_post.dart';
import 'package:find_my_pet_sg/widgets/image_slider_carousel.dart';
import 'package:find_my_pet_sg/widgets/lost_pet_post.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';

class MapsScreen extends StatefulWidget {
  final QueryDocumentSnapshot<Object?>? user;

  const MapsScreen({
    Key? key,
    required this.user,
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
    _customInfoWindowController.dispose();
    super.dispose();
  }

  Set<Marker> buildMarkers(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    int numberOfPosts = snapshot.data!.docs.length;
    Set<Marker> markers = {};
    for (int i = 0; i < numberOfPosts; i++) {
      markers.add(Marker(
          icon: snapshot.data!.docs[i].data()['type'] == "lost"
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose)
              : BitmapDescriptor.defaultMarker,
          markerId: MarkerId(snapshot.data!.docs[i].data()['postId']),
          position: LatLng(snapshot.data!.docs[i].data()['latitude'],
              snapshot.data!.docs[i].data()['longtitude']),
          onTap: () {
            _customInfoWindowController.addInfoWindow!(
                snapshot.data!.docs[i].data()['type'] == "lost"
                    ? LostPetPost(
                        snap: snapshot.data!.docs[i].data(),
                        user: widget.user,
                      )
                    : FoundPetPost(
                        snap: snapshot.data!.docs[i].data(),
                        user: widget.user,
                      ),
                LatLng(snapshot.data!.docs[i].data()['latitude'],
                    snapshot.data!.docs[i].data()['longtitude']));
          }

          // onTap: () => showDialog(
          //     context: context,
          //     builder: (BuildContext context) {
          //       return Dialog(
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(20.0),
          //         ),
          //         elevation: 0,
          //         backgroundColor: Colors.transparent,
          //         child: Container(
          //           width: 400,
          //           height: 330,
          //           child: snapshot.data!.docs[i].data()['type'] == "lost"
          //               ? LostPetPost(
          //             snap: snapshot.data!.docs[i].data(),
          //             user: widget.user,
          //           )
          //               : FoundPetPost(
          //             snap: snapshot.data!.docs[i].data(),
          //             user: widget.user,
          //           )
          //         ),
          //
          //       );
          //     }
          // )
          ));
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
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
                  onTap: (position) {
                    _customInfoWindowController.hideInfoWindow!();
                  },
                  onCameraMove: (position) {
                    _customInfoWindowController.onCameraMove!();
                  },
                  onMapCreated: (GoogleMapController controller) async {
                    _customInfoWindowController.googleMapController =
                        controller;
                  },
                  mapToolbarEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(1.290270, 103.851959),
                    zoom: 16,
                  ),
                  markers: buildMarkers(snapshot),
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
                              0,
                              0,
                            ),
                            zoom: 16,
                          )))),
                ),
                CustomInfoWindow(
                  controller: _customInfoWindowController,
                  width: 400,
                  height: 330,
                ),
              ],
            );
          }),
    );
  }
}
