import 'dart:io';
import 'dart:typed_data';

import 'package:find_my_pet_sg/widgets/upload_slider_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
// import 'package:find_my_pet_sg/widgets/arrow_back_button.dart';
import 'package:find_my_pet_sg/models/user.dart' as model;
import 'package:find_my_pet_sg/widgets/custom_made_button.dart';
import '../services/firestore_methods.dart';
import '../utils/pickImage.dart';
import '../utils/showSnackBar.dart';
import '../widgets/arrow_back_button.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_textfield_2.dart';
import '../widgets/reward_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _rewardController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
    _breedController.dispose();
    _locationController.dispose();
    _nameController.dispose();
    _dateController.dispose();
    _rewardController.dispose();
  }

  void setImageCallback(List<File> files) {
    setState(() {
      _files = files;
    });
  }

  void postImage() async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadFoundPost(
        "found",
        _descriptionController.text.trim(),
        _files!,
        _nameController.text.trim(),
        _locationController.text.trim(),
        latitude,
        longtitude,
        _dateController.text.trim(),
        isMale,
        widget._user!['name'].toString(),
        DateTime.now(),
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
      lastDate: DateTime(DateTime.now().year, 12, 31),
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
          // useCurrentLocation: true,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    infoText: "Name*",
                    hintText: "Name",
                    textInputType: TextInputType.name,
                    textEditingController: _nameController,
                    inputFormatters: [],
                    maxLines: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, bottom: 24.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Gender*"),
                          ],
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isMale = false;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  // color: isMale ? Colors.transparent : Colors.pink,
                                  borderRadius: BorderRadius.circular(4.0),
                                  border: Border.all(
                                      width: 2.0,
                                      color: isMale
                                          ? Colors.black12
                                          : Colors.pink),
                                ),
                                child: Row(children: [
                                  Text("Female"),
                                  Icon(
                                    Icons.female,
                                    color: Colors.red,
                                  )
                                ]),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isMale = true;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  // color: isMale ? Colors.pink : Colors.transparent,
                                  borderRadius: BorderRadius.circular(4.0),
                                  border: Border.all(
                                      width: 2.0,
                                      color: isMale
                                          ? Colors.pink
                                          : Colors.black12),
                                ),
                                child: Row(children: [
                                  Text("Male"),
                                  Icon(
                                    Icons.male,
                                    color: Colors.blue,
                                  )
                                ]),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0, right: 12.0, bottom: 20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Location*"),
                          ],
                        ),
                        Container(
                          color: Color(0xffF0F0F0),
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
                                    top: 2,
                                    left: 2,
                                    child: Text(
                                      _locationController.text,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20),
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
                        left: 12.0, right: 12.0, bottom: 20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Date*"),
                          ],
                        ),
                        Container(
                          color: Color(0xffF0F0F0),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(4.0),
                              onTap: _showDatePicker,
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
                                    top: 2,
                                    left: 2,
                                    child: Text(
                                      _dateController.text,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20),
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
                    inputFormatters: [],
                    maxLines: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
    );
  }
}
