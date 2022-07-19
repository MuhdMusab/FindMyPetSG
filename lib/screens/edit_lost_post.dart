import 'dart:io';
import 'dart:typed_data';

import 'package:find_my_pet_sg/services/database.dart';
import 'package:find_my_pet_sg/widgets/animal_search_delegate.dart';
import 'package:find_my_pet_sg/widgets/breed_editor.dart';
import 'package:find_my_pet_sg/widgets/date_field_picker.dart';
import 'package:find_my_pet_sg/widgets/gender_field_picker.dart';
import 'package:find_my_pet_sg/widgets/location_field_picker.dart';
import 'package:find_my_pet_sg/widgets/upload_slider_carousel.dart';
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

class EditLostPostScreen extends StatefulWidget {
  final Map<String, dynamic> snapshot;
  final int postIndex;
  final String username;
  Function callback;
  final String postId;

  EditLostPostScreen({
    Key? key,
    required this.snapshot,
    required this.postIndex,
    required this.username,
    required this.callback,
    required this.postId,
  }) : super(key: key);

  @override
  State<EditLostPostScreen> createState() => _EditLostPostScreenState();
}

class _EditLostPostScreenState extends State<EditLostPostScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final TextEditingController _descriptionController =
        TextEditingController(text: widget.snapshot['description']);
    final TextEditingController _locationController =
        TextEditingController(text: widget.snapshot['location']);
    final TextEditingController _nameController =
        TextEditingController(text: widget.snapshot['name']);
    final TextEditingController _dateController =
        TextEditingController(text: widget.snapshot['date']);
    final TextEditingController _rewardController =
        TextEditingController(text: widget.snapshot['reward'].toString());
    final TextEditingController _ageController =
        TextEditingController(text: widget.snapshot['age'].toString());
    final TextEditingController _breedController =
        TextEditingController(text: widget.snapshot['breed']);
    double latitude = widget.snapshot['latitude'];
    double longtitude = widget.snapshot['longtitude'];
    bool isMale = false;
    String _breed = widget.snapshot['breed'];

    @override
    void dispose() {
      super.dispose();
      _descriptionController.dispose();
      _locationController.dispose();
      _nameController.dispose();
      _dateController.dispose();
      _rewardController.dispose();
      _ageController.dispose();
    }

    void setAnimalTypeCallback(String animal) {
      setState(() {
        _breedController.text = animal;
      });
    }

    void uploadChanges() async {
      if (isLoading) {
      } else {
        setState(() {
          isLoading = true;
        });
        // start the loading
        if (_descriptionController.text.trim().length == 0 ||
            _nameController.text.trim().length == 0 ||
            _locationController.text.trim().length == 0 ||
            _breed == null ||
            _breed == "" ||
            _dateController.text.trim().length == 0 ||
            _ageController.text.trim().length == 0) {
          ScaffoldMessenger.of(context)..removeCurrentSnackBar();
          showSnackBar(context, "Incomplete fields given");
          setState(() {
            isLoading = false;
          });
        } else {
          DatabaseMethods.updatePostField(widget.username, widget.postId,
              'description', _descriptionController.text.trim());
          DatabaseMethods.updatePostField(widget.username, widget.postId,
              'name', _nameController.text.trim());
          DatabaseMethods.updatePostField(widget.username, widget.postId,
              'location', _locationController.text.trim());
          DatabaseMethods.updatePostField(
              widget.username, widget.postId, 'latitude', latitude);
          DatabaseMethods.updatePostField(
              widget.username, widget.postId, 'longtitude', longtitude);
          DatabaseMethods.updatePostField(
              widget.username, widget.postId, 'breed', _breedController.text);
          DatabaseMethods.updatePostField(
              widget.username, widget.postId, 'date', _dateController.text);
          DatabaseMethods.updatePostField(
            widget.username,
            widget.postId,
            'reward',
            _rewardController.text.trim() == ""
                ? 0
                : int.parse(_rewardController.text.trim()),
          );
          DatabaseMethods.updatePostField(
              widget.username, widget.postId, 'isMale', isMale);
          DatabaseMethods.updatePostField(widget.username, widget.postId, 'age',
              int.parse(_ageController.text.trim()));
          setState(() {
            isLoading = false;
          });
          showSnackBar(
            context,
            'Edited!',
          );
          Navigator.pop(context, true);
        }
      }
    }

    setLatitude(double lat) {
      latitude = lat;
    }

    setLongtitude(double long) {
      longtitude = long;
    }

    setGender(bool funcIsMale) {
      isMale = funcIsMale;
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
                    infoText: "Name*",
                    hintText: "Name",
                    textInputType: TextInputType.name,
                    textEditingController: _nameController,
                    inputFormatters: [],
                    maxLines: 1,
                  ),
                  CustomTextfield2(
                    infoText: "Age*",
                    hintText: "Age",
                    textInputType: TextInputType.number,
                    textEditingController: _ageController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLines: 1,
                  ),
                  GenderFieldPicker(isMale: isMale, setGender: setGender),
                  LocationFieldPicker(
                      locationController: _locationController,
                      latitude: setLatitude,
                      longtitude: setLongtitude),
                  DateFieldPicker(dateController: _dateController),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BreedEditor(
                            setAnimalTypeCallback: setAnimalTypeCallback,
                            breedController: _breedController),
                        RewardTextfield(
                          infoText: "Reward",
                          hintText: "Reward",
                          textInputType: TextInputType.datetime,
                          textEditingController: _rewardController,
                          maxLines: 1,
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
