import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
// import 'package:find_my_pet_sg/widgets/arrow_back_button.dart';
import 'package:find_my_pet_sg/models/user.dart' as model;
import 'package:find_my_pet_sg/widgets/sign_up_button.dart';
import '../providers/user_provider.dart';
import '../services/firestore_methods.dart';
import '../utils/pickImage.dart';
import '../utils/showSnackBar.dart';
import '../widgets/custom_textfield.dart';

class CreatePostScreen extends StatefulWidget {
  static String route = "CreatePostPage";
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
    _breedController.dispose();
    _locationController.dispose();
    _nameController.dispose();
    _dateController.dispose();
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
        // uid,
        _nameController.text.trim(),
        _locationController.text.trim(),
        _breedController.text.trim(),
        _dateController.text.trim(),
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

  @override
  Widget build(BuildContext context) {
    // final UserProvider userProvider = Provider.of<UserProvider>(context);
    // model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ArrowBackButton(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomTextfield(
                labelText: "Name",
                textInputType: TextInputType.name,
                textEditingController: _nameController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomTextfield(
                labelText: "Location",
                textInputType: TextInputType.text,
                textEditingController: _locationController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomTextfield(
                labelText: "Breed",
                textInputType: TextInputType.text,
                textEditingController: _breedController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomTextfield(
                labelText: "Date",
                textInputType: TextInputType.datetime,
                textEditingController: _dateController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomTextfield(
                labelText: "Description",
                textInputType: TextInputType.text,
                textEditingController: _descriptionController,
              ),
            ),
            ElevatedButton(
                child: Text("Upload image"),
                onPressed: () => _selectImage(context)),
            CustomMadeButton(
              isLoading: isLoading,
              text: "Post",
              onPressed: () => postImage(),
            ),
            Center(
              child: Text("CREATE POST PAGE", style: TextStyle(fontSize: 60)),
            ),
          ],
        ),
      ),
    );
  }
}
