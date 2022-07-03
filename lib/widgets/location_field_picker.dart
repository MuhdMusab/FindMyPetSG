import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'dart:io' show Platform;

class LocationFieldPicker extends StatefulWidget {
  final TextEditingController locationController;
  final Function latitude;
  final Function longtitude;

  LocationFieldPicker({
    Key? key,
    required this.locationController,
    required this.latitude,
    required this.longtitude,
  }) : super(key: key);

  @override
  State<LocationFieldPicker> createState() => _LocationFieldPickerState();
}

class _LocationFieldPickerState extends State<LocationFieldPicker> {

  void _showLocationPicker() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return PlacePicker(
          apiKey: Platform.isAndroid
              ? "AIzaSyDz1ECR-KPkB3vSSyCqvXq5j8lMhRJfTqM"
              : "AIzaSyCevtQ-g4R3ZZMse4jdPPsZ1xh7yhod_o4",
          onPlacePicked: (result) {
            setState(() {
              widget.locationController.text = result.formattedAddress.toString();
              widget.latitude(result.geometry!.location.lat);
              widget.longtitude(result.geometry!.location.lng);
            });
            Navigator.of(context).pop();
          },
          initialPosition: LatLng(1.290270, 103.851959),
          // useCurrentLocation: true,
        );
      }),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 12.0, right: 12.0, bottom: 12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Location*",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey
                ),
              ),
            ],
          ),
          Container(
            height: 51,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey.shade200),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(4.0),
                onTap: _showLocationPicker,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: Colors.transparent,
                      ),
                      height: 30,
                      width: 370,
                    ),
                    Positioned(
                      top: 14,
                      left: 2,
                      child: Text(
                        widget.locationController.text,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueGrey
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

