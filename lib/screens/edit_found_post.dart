import 'package:find_my_pet_sg/services/database.dart';
import 'package:find_my_pet_sg/widgets/breed_editor.dart';
import 'package:find_my_pet_sg/widgets/custom_made_button.dart';
import 'package:find_my_pet_sg/widgets/date_field_picker.dart';
import 'package:find_my_pet_sg/widgets/location_field_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config/constants.dart';
import '../utils/showSnackBar.dart';
import '../widgets/arrow_back_button.dart';
import '../widgets/custom_textfield_2.dart';

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
    final TextEditingController _breedController =
        TextEditingController(text: widget.snapshot['breed']);
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

    void setAnimalTypeCallback(String animal) {
      setState(() {
        _breed = animal;
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
            _dateController.text.trim().length == 0 ||
            _locationController.text.trim().length == 0 ||
            _breed == null ||
            _breed == "") {
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
              widget.username, widget.postId, 'breed', _breed);
          DatabaseMethods.updatePostField(
              widget.username, widget.postId, 'date', _dateController.text);
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
                              text: "Edit",
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
      ),
    );
  }
}
