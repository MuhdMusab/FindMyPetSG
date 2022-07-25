import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:find_my_pet_sg/services/database.dart';
import 'package:find_my_pet_sg/services/storage_methods.dart';
import 'package:flutter/material.dart';

class ProfilePictureWidget extends StatefulWidget {
  final Function callback;
  final StorageMethods storage;
  final String username;

  ProfilePictureWidget({
    Key? key,
    required this.callback,
    required this.storage,
    required this.username,
  }) : super(key: key);

  @override
  State<ProfilePictureWidget> createState() => _ProfilePictureWidgetState();
}

class _ProfilePictureWidgetState extends State<ProfilePictureWidget> {
  String? _profilePicUrl;
  NetworkImage? _img;
  int? _userIndex;
  String picUrl = '';

  Future showImageSource(BuildContext context, StorageMethods storage, String username) async {
    showModalBottomSheet(
        context: context,
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Choose image from Gallery'),
              onTap: () async {
                final img = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.custom,
                    allowedExtensions: ['jpg', 'png']);
                if (img == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('No file selected'),
                  ));
                  return null;
                }
                final path = img.files.single.path!;
                final fileName = '$username' + '_profile_picture';
                storage.uploadFile(path, fileName);
                String profilePicLink = await storage.downloadURL();
                DatabaseMethods.editProfilePicLink(
                    username, profilePicLink).then((value) async {
                  await Future.delayed(Duration(seconds: 3));
                  setState(() {
                    _imageVersion++;
                  });
                });
                FilePickerStatus.done;
                Navigator.pop(context);
              },
            ),
          ],
        ));
  }

  // void initState() {
  //   _profilePicUrl = widget.snapshot['profilePics'];
  //   _img = NetworkImage(_profilePicUrl!);
  // }
  int _imageVersion = 1;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<
                QuerySnapshot<Map<String, dynamic>>>
            profilePicSnapshot) {
          if (profilePicSnapshot.hasData) {
            for (int i = 0; i < profilePicSnapshot.data!.docs.length; i++) {
              if (profilePicSnapshot.data!.docs[i].data()['name'] == widget.username) {
                _userIndex = i;
                picUrl = profilePicSnapshot.data!.docs[i].data()['profilePics'];
              }
            }
            if (picUrl != '') {
              return Ink.image(
                key: ValueKey(Random().nextInt(100)),
                image: NetworkImage(
                  '$picUrl?v=$_imageVersion',
                ),
                fit: BoxFit.cover,
                width: 100,
                height: 100,
                child: InkWell(
                  key: ValueKey(Random().nextInt(100)),
                  onTap: () async {
                    showImageSource(
                        context, widget.storage, widget.username);
                  },
                ),
              );
            } else {
              return Ink.image(
                image: const AssetImage(
                  "assets/images/default_user_icon.png",
                ),
                fit: BoxFit.cover,
                width: 100,
                height: 100,
                child: InkWell(
                  onTap: () async {
                    showImageSource(
                        context, widget.storage, widget.username);
                  },
                ),
              );
            }
          }
          return Ink.image(
            image: const AssetImage(
              "assets/images/default_user_icon.png",
            ),
            fit: BoxFit.cover,
            width: 100,
            height: 100,
            child: InkWell(
              onTap: () async {
                showImageSource(
                    context, widget.storage, widget.username);
              },
            ),
          );
        });
  }
}
