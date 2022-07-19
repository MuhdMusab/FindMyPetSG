import 'dart:async';
import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:find_my_pet_sg/config/constants.dart';
import 'package:find_my_pet_sg/map_markers/map_markers.dart';
import 'package:find_my_pet_sg/models/filter_model.dart';
import 'package:find_my_pet_sg/models/post_type_model.dart';
import 'package:find_my_pet_sg/screens/maps_screen.dart';
import 'package:find_my_pet_sg/services/notification_service.dart';
import 'package:find_my_pet_sg/utils/showSnackBar.dart';
import 'package:find_my_pet_sg/widgets/custom_dialog_box.dart';
import 'package:find_my_pet_sg/widgets/full_posts.dart';
import 'package:find_my_pet_sg/widgets/widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_pet_sg/models/filter_model.dart';
import 'package:find_my_pet_sg/models/category.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_geofence/geofence.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../widgets/lost_pet_post.dart';
import '../widgets/found_pet_post.dart';
import '../widgets/filter_button.dart';
import 'create_lost_post_screen.dart';
import 'package:workmanager/workmanager.dart';

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
  Position? userPosition;
  int value = 0;
  @override
  bool get wantKeepAlive => true;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  StreamSubscription<Position>? _positionStreamSubscription;

  void scheduleNotification(String title, String subtitle) {
    print("scheduling one with $title and $subtitle");
    var rng = new Random();
    Future.delayed(Duration(seconds: 5)).then((result) async {
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'your channel id', 'your channel name',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker');
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          rng.nextInt(100000), title, subtitle, platformChannelSpecifics,
          payload: 'item x');
    });
  }

  /// Check if there is lost pet to look out for and send notifications
  void sendLookoutNotification(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    /// Function to check if pet is went missing within past 3 days
    bool isRecent(DateTime dateOfLostPet) {
      return DateTime.now().difference(dateOfLostPet).inDays <= 3;
    }

    /// Function to check if is nearby and within 1000m
    double distanceAway(double lostPetLatitude, double lostPetLongitude) {
      return Geolocator.distanceBetween(userPosition!.latitude,
          userPosition!.longitude, lostPetLatitude, lostPetLongitude);
    }

    int numberOfPosts = snapshot.data!.docs.length;
    for (int index = 0; index < numberOfPosts; index++) {
      double lostPetLatitude = snapshot.data!.docs[index].get('latitude');
      double lostPetLongitude = snapshot.data!.docs[index].get('longtitude');
      String dateOfLostPet = snapshot.data!.docs[index].get('date');
      DateTime dateTimeOfLostPet = DateFormat('d/M/y').parse(dateOfLostPet);
      double distance = distanceAway(lostPetLatitude, lostPetLongitude);
      if (distance < 1000 && isRecent(dateTimeOfLostPet)) {
        String name = (snapshot.data!.docs[index].get('name'));
        String formattedDistance = distance.toStringAsFixed(2);
        scheduleNotification("Lookout for $name",
            "Lost on $dateOfLostPet \nPet was lost at $formattedDistance m away from current location");
      }
    }
  }

  /// Request location permission and get userPosition
  void _getUserPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position userLocation = await Geolocator.getCurrentPosition();

    setState(() {
      userPosition = userLocation;
    });
  }

  @override
  void dispose() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription!.cancel();
      _positionStreamSubscription = null;
    }

    super.dispose();
  }

  void initState() {
    super.initState();
    buildMarkerIcons();
    this._getUserPosition();

    final service = FlutterBackgroundService();
    //listenToDatabase();
    final String username = widget._user!['name'].toString();
    DatabaseReference ref = FirebaseDatabase.instance.ref('chatroom').child(username);
    Stream<DatabaseEvent> stream = ref.onValue;
    DateTime currTime = DateTime.now();
    stream.listen((DatabaseEvent event) {
      Map<dynamic, dynamic> chatrooms = Map<dynamic, dynamic>.from(
          (event as dynamic).snapshot.value);
      Map<dynamic, dynamic>? otherChatters;
      chatrooms.forEach((key, value) {
        otherChatters = Map<String, dynamic>.from(value);
        DatabaseReference ref = FirebaseDatabase.instance.ref(otherChatters?.values.first).child(username).child('messages');
        ref.onChildAdded.listen((event) {
          Map<dynamic, dynamic> currentMap = Map<dynamic, dynamic>.from(
              (event as dynamic).snapshot.value);
          if (currentMap.containsKey('date')) {
            DateTime date = DateTime.parse(currentMap['date'] as String);
            if (date.difference(currTime).inSeconds > 0) {
              Map<String, dynamic> map = {
                'otherUser': otherChatters?.values.first,
                'text' : currentMap['text'],
              };
              service.invoke('newMessage', map);
            }
          }
        });
      });
    });
    CollectionReference<Map<String, dynamic>> a = FirebaseFirestore.instance.collection('posts');
    a.snapshots().listen((QuerySnapshot<Map<String, dynamic>> event) {
      List<DocumentChange<Map<String, dynamic>>> a = event.docChanges;
      DateTime currTime = DateTime.now();
      for (DocumentChange<Map<String, dynamic>> doc in a) {
        if (doc.type == DocumentChangeType.added) {
          Map<String, dynamic> currMap = doc.doc.data()!;
          double distanceBetweenUserAndPost = Geolocator.distanceBetween(userPosition!.latitude,
              userPosition!.longitude, currMap['latitude'], currMap['longtitude']);
          print(distanceBetweenUserAndPost);
          if (distanceBetweenUserAndPost <= 1000) {
            if (currMap.containsKey('dateTimePosted')) {
              Timestamp timestamp = currMap['dateTimePosted'];
              if (currTime
                  .difference(timestamp.toDate())
                  .inHours <= 1) {
                if (currMap.containsKey('name')) {
                  Map<String, dynamic> map = {
                    'name': currMap['name'],
                    'type': currMap['type'],
                    'location': currMap['location'],
                    'breed': currMap['breed'],
                  };
                  service.invoke('lookout', map);
                } else {
                  Map<String, dynamic> map = {
                    'type': currMap['type'],
                    'location': currMap['location'],
                    'breed': currMap['breed'],
                  };
                  service.invoke('lookout', map);
                }
              }
            }
          }
        }
      }
    });

    /// When app is running, everytime user moves by 500m, variable userPosition is updated
    _positionStreamSubscription = Geolocator.getPositionStream(
            locationSettings: LocationSettings(distanceFilter: 500))
        .listen((Position? position) {
      if (position == null) {
        print('unknown');
      } else {
        userPosition = position;
        showSnackBar(context,
            'Current location: ${userPosition!.latitude.toString()}, ${userPosition!.longitude.toString()}');
      }
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
    return StreamBuilder(
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
        if (userPosition != null) {
          sendLookoutNotification(snapshot);
        }
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
                    padding:
                        const EdgeInsets.only(left: 12, top: 18, bottom: 10),
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
                                // _getUserLocation();
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
              (value == 1 && userPosition != null)
                  ? MapsScreen(
                      filters: filters,
                      user: widget._user,
                      initialLatLng: LatLng(
                          userPosition!.latitude!, userPosition!.longitude!))
                  : (value == 1 && userPosition == null)
                      ? Padding(
                          padding: const EdgeInsets.only(top: 250.0),
                          child: Text(
                            "Enable Google's location services for map view",
                            style:
                                TextStyle(fontSize: 30, color: Colors.black45),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : FullPosts(user: widget._user, filters: filters),
            ],
          ),
        );
      },
    );
  }
}
