import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

BitmapDescriptor? foundDogMarker;
BitmapDescriptor? foundCatMarker;
BitmapDescriptor? foundBirdMarker;
BitmapDescriptor? foundOthersMarker;
BitmapDescriptor? lostDogMarker;
BitmapDescriptor? lostCatMarker;
BitmapDescriptor? lostBirdMarker;
BitmapDescriptor? lostOthersMarker;
BitmapDescriptor? lookoutDogMarker;
BitmapDescriptor? lookoutCatMarker;
BitmapDescriptor? lookoutBirdMarker;
BitmapDescriptor? lookoutOthersMarker;

Future<Uint8List> getBytesFromAsset({String? path, int? width}) async {
  ByteData data = await rootBundle.load(path!);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

void buildMarkerIcons() {
  int size = 140;
  getBytesFromAsset(path: "assets/images/found_dog.png", width: size)
      .then((icon) {
    foundDogMarker = BitmapDescriptor.fromBytes(icon);
  });
  getBytesFromAsset(path: "assets/images/found_cat.png", width: size)
      .then((icon) {
    foundCatMarker = BitmapDescriptor.fromBytes(icon);
  });
  getBytesFromAsset(path: "assets/images/found_bird.png", width: size)
      .then((icon) {
    foundBirdMarker = BitmapDescriptor.fromBytes(icon);
  });
  getBytesFromAsset(path: "assets/images/found_others.png", width: size)
      .then((icon) {
    foundOthersMarker = BitmapDescriptor.fromBytes(icon);
  });
  getBytesFromAsset(path: "assets/images/lost_dog.png", width: size)
      .then((icon) {
    lostDogMarker = BitmapDescriptor.fromBytes(icon);
  });
  getBytesFromAsset(path: "assets/images/lost_cat.png", width: size)
      .then((icon) {
    lostCatMarker = BitmapDescriptor.fromBytes(icon);
  });
  getBytesFromAsset(path: "assets/images/lost_bird.png", width: size)
      .then((icon) {
    lostBirdMarker = BitmapDescriptor.fromBytes(icon);
  });
  getBytesFromAsset(path: "assets/images/lost_others.png", width: size)
      .then((icon) {
    lostOthersMarker = BitmapDescriptor.fromBytes(icon);
  });
  getBytesFromAsset(path: "assets/images/lookout_lost_dog.png", width: size)
      .then((icon) {
    lookoutDogMarker = BitmapDescriptor.fromBytes(icon);
  });
  getBytesFromAsset(path: "assets/images/lookout_lost_cat.png", width: size)
      .then((icon) {
    lookoutCatMarker = BitmapDescriptor.fromBytes(icon);
  });
  getBytesFromAsset(path: "assets/images/lookout_lost_bird.png", width: size)
      .then((icon) {
    lookoutBirdMarker = BitmapDescriptor.fromBytes(icon);
  });
  getBytesFromAsset(path: "assets/images/lookout_lost_others.png", width: size)
      .then((icon) {
    lookoutOthersMarker = BitmapDescriptor.fromBytes(icon);
  });
}
