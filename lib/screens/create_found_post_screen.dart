import 'dart:io';
import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_pet_sg/widgets/animal_search_delegate.dart';
import 'package:find_my_pet_sg/widgets/custom_made_button.dart';
import 'package:find_my_pet_sg/widgets/upload_slider_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';

import '../config/constants.dart';
import '../services/firestore_methods.dart';
import '../utils/showSnackBar.dart';
import '../widgets/arrow_back_button.dart';
import '../widgets/custom_textfield_2.dart';

class CreateFoundPostScreen extends StatefulWidget {
  static String route = "CreatePostPage";
  QueryDocumentSnapshot<Object?>? _user;

  CreateFoundPostScreen(QueryDocumentSnapshot<Object?>? user) {
    this._user = user;
  }

  @override
  State<CreateFoundPostScreen> createState() => _CreateFoundPostScreenState();
}

class _CreateFoundPostScreenState extends State<CreateFoundPostScreen> {
  List<File>? _files;
  bool isMale = false;
  bool isLoading = false;
  double latitude = 0;
  double longtitude = 0;
  String? _breed;
  GoogleMapController? googleMapController;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _nameController.dispose();
    _dateController.dispose();
    googleMapController?.dispose();
  }

  void setImageCallback(List<File> files) {
    setState(() {
      _files = files;
    });
  }

  void setAnimalTypeCallback(String animal) {
    setState(() {
      _breed = animal;
    });
  }

  void postImage() async {
    if (isLoading) {
    } else {
      setState(() {
        isLoading = true;
      });
      // start the loading
      if (_descriptionController.text.trim().length == 0 ||
          _locationController.text.trim().length == 0 ||
          _breed == null ||
          _dateController.text.trim().length == 0) {
        ScaffoldMessenger.of(context)..removeCurrentSnackBar();
        showSnackBar(context, "Incomplete fields given");
        setState(() {
          isLoading = false;
        });
      } else if (_files!.length == 0) {
        ScaffoldMessenger.of(context)..removeCurrentSnackBar();
        showSnackBar(context, "Please upload at least one image");
        setState(() {
          isLoading = false;
        });
      } else {
        try {
          // upload to storage and db
          String res = await FireStoreMethods().uploadFoundPost(
            "found",
            _descriptionController.text.trim(),
            _files!,
            _locationController.text.trim(),
            latitude,
            longtitude,
            _dateController.text.trim(),
            widget._user!['name'].toString(),
            DateTime.now(),
            _breed == null || _breed == '' ? 'Others' : _breed!,
            _nameController.text == null || _nameController.text == ""
                ? ""
                : _nameController.text.trim(),
          );
          if (res == "success") {
            setState(() {
              isLoading = false;
            });
            showSnackBar(
              context,
              'Posted!',
            );
            clearImage();
            Navigator.pop(context, true);
          } else {
            showSnackBar(context, res);
          }
        } catch (err) {
          setState(() {
            isLoading = false;
          });
          showSnackBar(
            context,
            err.toString(),
          );
        }
      }
    }
  }

  void clearImage() {
    setState(() {
      _files = null;
    });
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.pink,
            ),
          ),
          child: child!,
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          _dateController.text = value.day.toString() +
              "/" +
              value.month.toString() +
              "/" +
              value.year.toString();
        });
      }
    });
  }

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
              _locationController.text = result.formattedAddress.toString();
              latitude = result.geometry!.location.lat;
              longtitude = result.geometry!.location.lng;
            });
            Navigator.of(context).pop();
          },
          initialPosition: LatLng(1.290270, 103.851959),
          onMapCreated: (controller) {
            googleMapController = controller;
          },
          useCurrentLocation: true,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              ArrowBackButton(),
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Stack(
                        children: [
                          UploadSliderCarousel(
                              setImageCallback: setImageCallback),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextfield2(
                      infoText: "Name",
                      hintText: "Name",
                      textInputType: TextInputType.name,
                      textEditingController: _nameController,
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(
                            petNameCharacterLimit)
                      ],
                      maxLines: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 12.0, bottom: 12.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Location*",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.blueGrey),
                              ),
                            ],
                          ),
                          Container(
                            height: 51,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.blueGrey.shade200),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(4.0),
                                onTap: () {
                                  FocusScope.of(context).unfocus();

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return PlacePicker(
                                        apiKey: Platform.isAndroid
                                            ? "AIzaSyDz1ECR-KPkB3vSSyCqvXq5j8lMhRJfTqM"
                                            : "AIzaSyCevtQ-g4R3ZZMse4jdPPsZ1xh7yhod_o4",
                                        onPlacePicked: (result) {
                                          setState(() {
                                            _locationController.text = result
                                                .formattedAddress
                                                .toString();
                                            latitude =
                                                result.geometry!.location.lat;
                                            longtitude =
                                                result.geometry!.location.lng;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        initialPosition:
                                            LatLng(1.290270, 103.851959),
                                        onMapCreated: (controller) {
                                          googleMapController = controller;
                                        },
                                        useCurrentLocation: true,
                                      );
                                    }),
                                  );
                                  // _showLocationPicker;
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                        color: Colors.transparent,
                                      ),
                                      height: 30,
                                      width: 370,
                                    ),
                                    Positioned(
                                      top: 14,
                                      left: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0),
                                        child: Text(
                                          _locationController.text,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.blueGrey),
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
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 12.0, bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Date*",
                            style:
                                TextStyle(fontSize: 16, color: Colors.blueGrey),
                          ),
                          Container(
                            height: 51,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.blueGrey.shade200),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(4.0),
                                onTap: _showDatePicker,
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                        color: Colors.transparent,
                                      ),
                                      height: 30,
                                      width: 370,
                                    ),
                                    Positioned(
                                      top: 14,
                                      left: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0),
                                        child: Text(
                                          _dateController.text,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.blueGrey),
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
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12.0, right: 12.0, bottom: 12.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Type of Animal*",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.blueGrey),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 51,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.blueGrey.shade200),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(4.0),
                                      onTap: () => showSearch(
                                          context: context,
                                          delegate: AnimalSearchDelegate(
                                              callback: setAnimalTypeCallback,
                                              callback2: (String temp) {})),
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                              color: Colors.transparent,
                                            ),
                                            height: 30,
                                            width: 370,
                                          ),
                                          Positioned(
                                            top: 14,
                                            left: 2,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              child: Text(
                                                _breed == null ||
                                                        _breed!.isEmpty
                                                    ? ""
                                                    : _breed!,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.blueGrey),
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
                          ),
                          CustomTextfield2(
                            infoText: "Description*",
                            hintText: "Description",
                            textInputType: TextInputType.text,
                            textEditingController: _descriptionController,
                            inputFormatters: [
                              new LengthLimitingTextInputFormatter(
                                  descriptionCharacterLimit)
                            ],
                            maxLines: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: CustomMadeButton(
                              isLoading: isLoading,
                              text: "Post",
                              onPressed: () => postImage(),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
