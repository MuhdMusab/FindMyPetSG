import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class CreatePostScreen extends StatefulWidget {
  static String route = "CreatePostPage";
  QueryDocumentSnapshot<Object?>? _user;

  CreatePostScreen(QueryDocumentSnapshot<Object?>? user) {
    this._user = user;
  }

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  Uint8List? _file;
  bool isMale = false;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _rewardController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
    _breedController.dispose();
    _locationController.dispose();
    _nameController.dispose();
    _dateController.dispose();
    _rewardController.dispose();
    _ageController.dispose();
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Report'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void postImage() async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadPost(
        _descriptionController.text.trim(),
        _file!,
        _nameController.text.trim(),
        _locationController.text.trim(),
        _breedController.text.trim(),
        _dateController.text.trim(),
        int.parse(_rewardController.text.trim()),
        int.parse(_ageController.text.trim()),
        isMale,
        widget._user!['name'].toString(),
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
      _file = null;
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
                  Center(
                    child: Stack(
                      children: [
                        _file != null
                            ? CircleAvatar(
                                radius: 64,
                                backgroundImage: MemoryImage(_file!),
                              )
                            : const CircleAvatar(
                                radius: 64,
                                backgroundImage: NetworkImage(
                                    'https://i.pinimg.com/originals/f9/58/18/f95818f914844d2b1cf7a45b232061d1.jpg'),
                              ),
                        Positioned(
                          bottom: -10,
                          left: 80,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.pink,
                            ),
                            child: IconButton(
                              color: Colors.white,
                              onPressed: () => _selectImage(context),
                              icon: const Icon(Icons.add_a_photo),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  CustomTextfield2(
                    infoText: "Name*",
                    hintText: "Name",
                    textInputType: TextInputType.name,
                    textEditingController: _nameController,
                    inputFormatters: [],
                    maxLength: 20,
                    maxLines: 1,
                  ),
                  CustomTextfield2(
                    infoText: "Age*",
                    hintText: "Age",
                    textInputType: TextInputType.number,
                    textEditingController: _ageController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 3,
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
                  CustomTextfield2(
                    infoText: "Location*",
                    hintText: "Location",
                    textInputType: TextInputType.text,
                    textEditingController: _locationController,
                    inputFormatters: [],
                    maxLength: 20,
                    maxLines: 1,
                  ),
                  CustomTextfield2(
                    infoText: "Breed*",
                    hintText: "Breed",
                    textInputType: TextInputType.text,
                    textEditingController: _breedController,
                    inputFormatters: [],
                    maxLength: 20,
                    maxLines: 1,
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
                  RewardTextfield(
                    infoText: "Reward",
                    hintText: "Reward",
                    textInputType: TextInputType.datetime,
                    textEditingController: _rewardController,
                    maxLength: 5,
                    maxLines: 1,
                  ),
                  CustomTextfield2(
                    infoText: "Description*",
                    hintText: "Description",
                    textInputType: TextInputType.text,
                    textEditingController: _descriptionController,
                    inputFormatters: [],
                    maxLength: 100,
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
