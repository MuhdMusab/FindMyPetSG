import 'dart:io';
import 'dart:typed_data';

import 'package:find_my_pet_sg/services/database.dart';
import 'package:find_my_pet_sg/widgets/date_field_picker.dart';
import 'package:find_my_pet_sg/widgets/gender_field_picker.dart';
import 'package:find_my_pet_sg/widgets/location_field_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:find_my_pet_sg/models/user.dart' as model;
import 'package:find_my_pet_sg/widgets/custom_made_button.dart';
import '../services/firestore_methods.dart';
import '../utils/showSnackBar.dart';
import '../widgets/arrow_back_button.dart';
import '../widgets/custom_textfield_2.dart';
import '../widgets/reward_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:searchfield/searchfield.dart';
import 'dart:io' show Platform;

class EditFoundPostScreen extends StatefulWidget {
  final Map<String, dynamic> snapshot;
  final int postIndex;
  final String username;
  Function callback;
  final String postId;

  EditFoundPostScreen({
    Key? key,
    required this.snapshot,
    required this.postIndex,
    required this.username,
    required this.callback,
    required this.postId,
  }) : super(key: key);

  @override
  State<EditFoundPostScreen> createState() => _EditFoundPostScreenState();
}

class _EditFoundPostScreenState extends State<EditFoundPostScreen> {
  bool isLoading = false;
  final _searchFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final TextEditingController _descriptionController = TextEditingController(text: widget.snapshot['description']);
    final TextEditingController _locationController = TextEditingController(text: widget.snapshot['location']);
    final TextEditingController _nameController = TextEditingController(text: widget.snapshot['name']);
    final TextEditingController _dateController = TextEditingController(text: widget.snapshot['date']);
    double latitude = widget.snapshot['latitude'];
    double longtitude = widget.snapshot['longtitude'];
    String _breed = widget.snapshot['breed'];

    @override
    void dispose() {
      super.dispose();
      _descriptionController.dispose();
      _locationController.dispose();
      _nameController.dispose();
      _dateController.dispose();
    }

    void uploadChanges() async {
      setState(() {
        isLoading = true;
      });
      // start the loading
      if (!_searchFormKey.currentState!.validate() ||_descriptionController.text.trim().length == 0
          || _locationController.text.trim().length == 0 || _breed == null || _breed == "" ||
          _dateController.text.trim().length == 0) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar();
        showSnackBar(context, "Incomplete fields given");
        setState(() {
          isLoading = false;
        });
      } else {
        DatabaseMethods.updatePostField(widget.username, widget.postId, 'description', _descriptionController.text.trim());
        DatabaseMethods.updatePostField(widget.username, widget.postId, 'name', _nameController.text.trim());
        DatabaseMethods.updatePostField(widget.username, widget.postId, 'location', _locationController.text.trim());
        DatabaseMethods.updatePostField(widget.username, widget.postId, 'latitude', latitude);
        DatabaseMethods.updatePostField(widget.username, widget.postId, 'longtitude', longtitude);
        DatabaseMethods.updatePostField(widget.username, widget.postId, 'breed', _breed);
        DatabaseMethods.updatePostField(widget.username, widget.postId, 'date', _dateController);
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'Posted!',
        );
        Navigator.pop(context, true);
      }
    }

    bool isInSuggestions(String type) {
      List suggestions = [
        'Bird',
        'Cat',
        'Chinchilla',
        'Crab',
        'Dog',
        'Frog',
        'Gerbil',
        'Guinea pig',
        'Hamster',
        'Mouse',
        'Rabbit',
        'Tortoise',
        'Turtle',
        'Others',
      ];
      for (String str in suggestions) {
        if (str == type) {
          return true;
        }
      }
      return false;
    }

    setLatitude(double lat) {
      latitude = lat;
    }

    setLongtitude(double long) {
      longtitude = long;
    }

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
                  CustomTextfield2(
                    infoText: "Name",
                    hintText: "Name",
                    textInputType: TextInputType.name,
                    textEditingController: _nameController,
                    inputFormatters: [],
                    maxLines: 1,
                  ),
                  LocationFieldPicker(locationController: _locationController, latitude: setLatitude, longtitude: setLongtitude),
                  DateFieldPicker(dateController: _dateController),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.0),
                                child: Text("Enter the found pet's type of animal*", style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blueGrey
                                ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Form(
                                  key: _searchFormKey,
                                  child: SearchField(
                                    initialValue: SearchFieldListItem(widget.snapshot['breed'] as String),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter the type of animal';
                                      } else if (!isInSuggestions(value)) {
                                        return 'Please select a suitable type of animal';
                                      } else {
                                        return null;
                                      }
                                    },
                                    hint: widget.snapshot['breed'] as String,
                                    hasOverlay: false,
                                    searchInputDecoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blueGrey.shade200,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: Colors.blue.withOpacity(0.8),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    maxSuggestionsInViewPort: 4,
                                    itemHeight: 40,
                                    suggestionsDecoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    onSubmit: (value) {
                                      _breed = value;
                                    },
                                    onSuggestionTap: (SearchFieldListItem value) {
                                      _breed = value.searchKey;
                                    },
                                    suggestions: [
                                      'Bird',
                                      'Cat',
                                      'Chinchilla',
                                      'Crab',
                                      'Dog',
                                      'Frog',
                                      'Gerbil',
                                      'Guinea pig',
                                      'Hamster',
                                      'Mouse',
                                      'Rabbit',
                                      'Tortoise',
                                      'Turtle',
                                      'Others',
                                    ].map((e) => SearchFieldListItem(e)).toList(),
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
                            onPressed: () => uploadChanges(),
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
    );
  }
}
