import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:find_my_pet_sg/config/constants.dart';
import 'package:find_my_pet_sg/models/filter_model.dart';
import 'package:find_my_pet_sg/models/post_type_model.dart';
import 'package:find_my_pet_sg/screens/maps_screen.dart';
import 'package:find_my_pet_sg/services/notification_service.dart';
import 'package:find_my_pet_sg/widgets/custom_dialog_box.dart';
import 'package:find_my_pet_sg/widgets/full_posts.dart';
import 'package:find_my_pet_sg/widgets/widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_pet_sg/models/filter_model.dart';
import 'package:find_my_pet_sg/models/category.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../widgets/lost_pet_post.dart';
import '../widgets/found_pet_post.dart';
import '../widgets/filter_button.dart';
import 'create_lost_post_screen.dart';
import 'package:location/location.dart';

const TextStyle _textStyle = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.bold,
  letterSpacing: 2,
  fontStyle: FontStyle.italic,
);

class ExploreScreen extends StatefulWidget {
  QueryDocumentSnapshot<Object?>? _user;

  ExploreScreen(QueryDocumentSnapshot<Object?>? user) {
    this._user = user;
  }

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with AutomaticKeepAliveClientMixin<ExploreScreen> {
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  LocationData? _userLocation;
  int value = 0;
  @override
  bool get wantKeepAlive => true;

  void initState() {
    super.initState();
    _activateListeners();
  }

  Future<void> _getUserLocation() async {
    Location location = Location();

    // Check if location service is enable
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Check if permission is granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final _locationData = await location.getLocation();
    setState(() {
      _userLocation = _locationData;
    });
  }

  void _activateListeners() {
    final String username = widget._user!['name'].toString();
    FirebaseDatabase.instance
        .ref()
        .child(username)
        .onChildChanged
        .listen((event) {
      //final String message = event.snapshot.value as String;
      //NotificationService().showNotification(1, "new message ", message, 2);
    });
  }

  List<Filter?> filters = [];

  _callback(List<Filter?> newFilters) {
    filters = newFilters;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: pink(),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomDialogBox(
                    title: "Have you Lost or Found a pet?",
                    text: "yes",
                    user: widget._user);
              });
        },
        child: new Icon(
          Icons.add,
          size: 40.0,
          color: Colors.white,
        ),
        elevation: 8.0,
      ),
      body: Column(
        children: [
          SafeArea(
            child: Stack(children: [
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 18, bottom: 10),
                child: FilterButton(
                  callback: _callback,
                  user: widget._user,
                ),
              ),
              Positioned(
                top: 14,
                right: 10,
                child: Container(
                    height: 40,
                    child: AnimatedToggleSwitch<int>.size(
                        current: value,
                        values: [0, 1],
                        indicatorBorderRadius: BorderRadius.zero,
                        borderWidth: 1.0,
                        borderRadius: BorderRadius.circular(8.0),
                        iconOpacity: 0.2,
                        indicatorSize: Size.fromWidth(60),
                        iconSize: const Size.square(40),
                        iconBuilder: (value, size) {
                          IconData data = MdiIcons.mapMarker;
                          if (value.isEven) data = Icons.list;
                          return Icon(
                            data,
                            size: min(size.width, size.height),
                            color: Colors.pink,
                          );
                        },
                        borderColor: lightPink(),
                        colorBuilder: (i) =>
                        i.isEven ? lightPink() : lightPink(),
                        onChanged: (i) {
                          if (i == 0) {
                            setState(() {
                              value = 0;
                            });
                          } else {
                            _getUserLocation();
                            setState(() {
                              value = 1;
                            });
                          }
                        })),
              ),
            ]),
          ),
          Divider(
            height: 1,
            thickness: 2,
            color: Colors.white,
          ),
          (value == 1 && _userLocation != null)
              ? MapsScreen(
                  filters: filters,
              user: widget._user,
              currentLatLng: LatLng(
                  _userLocation!.latitude!, _userLocation!.longitude!))
              : (value == 1 && _userLocation == null)
                  ? Padding(
                      padding: const EdgeInsets.only(top: 250.0),
                      child: Text(
                        "Enable Google's location services for map view",
                        style: TextStyle(fontSize: 30, color: Colors.black45),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : FullPosts(user: widget._user, filters: filters),
        ],
      ),
    );
  }
}
