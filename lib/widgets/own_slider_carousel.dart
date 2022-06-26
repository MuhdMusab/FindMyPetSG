import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:find_my_pet_sg/services/database.dart';
import 'package:find_my_pet_sg/services/storage_methods.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:find_my_pet_sg/widgets/upload_slider_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
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

class OwnSliderCarousel extends StatefulWidget {
  //final imageArray;
  final int postIndex;
  final String username;
  List<dynamic>? posts;
  Function callback;

  OwnSliderCarousel({
    Key? key,
    required this.postIndex,
    required this.username,
    required this.posts,
    required this.callback,
  }) : super(key: key);

  @override
  State<OwnSliderCarousel> createState() => _OwnSliderCarouselState();
}

class _OwnSliderCarouselState extends State<OwnSliderCarousel> {
  int activeIndex = 0;
  int _currentPostSize = 0;

  _selectImage(BuildContext parentContext, int postIndex) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Add another image'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  if (widget.posts!.length >= 4) {
                    //do nothing
                  } else {
                    Navigator.pop(context);
                    XFile? xfile = await ImagePicker.platform.getImageFromSource(
                        source: ImageSource.camera);
                    File file = (await cropSquareImage(File(xfile!.path)));
                    final StorageMethods storageMethods = StorageMethods();
                    List<String> urls = await storageMethods.uploadImageToStorage('posts', file.readAsBytesSync());
                    await DatabaseMethods.addPost(widget.username, urls[0], postIndex,);
                    await DatabaseMethods.addStorageReference(widget.username, urls[1], postIndex,);
                    widget.callback();
                  }
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  if (widget.posts!.length >= 4) {
                    // do nothing
                  } else {
                    XFile? xfile = await ImagePicker.platform.getImageFromSource(
                        source: ImageSource.camera);
                    File file = (await cropSquareImage(File(xfile!.path)));
                    final StorageMethods storageMethods = StorageMethods();
                    List<String> urls = await storageMethods.uploadImageToStorage('posts', file.readAsBytesSync());
                    await DatabaseMethods.addPost(widget.username, urls[0], postIndex,);
                    await DatabaseMethods.addStorageReference(widget.username, urls[1], postIndex,);
                    widget.callback();
                  }
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

  _editImage(BuildContext parentContext, int postIndex, int activeIndex) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Edit the image'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  XFile? xfile = await ImagePicker.platform.getImageFromSource(
                      source: ImageSource.camera);
                  File file = (await cropSquareImage(File(xfile!.path)));
                  String prevRef = await DatabaseMethods.getStorageReferenceAtIndex(widget.username, postIndex, activeIndex);
                  final StorageMethods storageMethods = StorageMethods();
                  storageMethods.deleteImageFromStorage(prevRef);
                  List<String> urls = await storageMethods.uploadImageToStorage('posts', file.readAsBytesSync());
                  await DatabaseMethods.editPostAtIndex(widget.username, urls[0], postIndex, activeIndex);
                  await DatabaseMethods.editStorageReferenceAtIndex(widget.username, urls[1], postIndex, activeIndex);
                  widget.callback();
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.pop(context);
                  XFile? xfile = await ImagePicker.platform.getImageFromSource(
                      source: ImageSource.gallery);
                  File file = (await cropSquareImage(File(xfile!.path)));
                  String prevRef = await DatabaseMethods.getStorageReferenceAtIndex(widget.username, postIndex, activeIndex);
                  final StorageMethods storageMethods = StorageMethods();
                  storageMethods.deleteImageFromStorage(prevRef);
                  List<String> urls = await storageMethods.uploadImageToStorage('posts', file.readAsBytesSync());
                  await DatabaseMethods.editPostAtIndex(widget.username, urls[0], postIndex, activeIndex);
                  await DatabaseMethods.editStorageReferenceAtIndex(widget.username, urls[1], postIndex, activeIndex);
                  widget.callback();
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
          child: InkWell(
              customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              splashColor: Colors.black12,
              onTap: () {
                if (activeIndex == widget.posts!.length) {
                  _selectImage(context, widget.postIndex);
                } else {
                  _editImage(context, widget.postIndex, activeIndex);
                }
              },
              child: Container(
                  width: 390,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        spreadRadius: 0,
                        blurRadius: 6,
                        blurStyle: BlurStyle.outer,
                      )
                    ],
                  ),
                  child:
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: Stack(
                      children: [
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CarouselSlider.builder(
                                itemCount: widget.posts!.length < 4 ? widget.posts!.length + 1 : widget.posts!.length,
                                options: CarouselOptions(
                                  enableInfiniteScroll: false,
                                  viewportFraction: 1,
                                  height: 200,
                                  onPageChanged: (index, reason) =>
                                      setState(() => activeIndex = index),

                                ),
                                itemBuilder: (context, index, realIndex) {
                                  if (index == widget.posts!.length && widget.posts!.length < 4) {
                                    return Image.asset(
                                      "assets/images/uploadcameraimage.png",
                                      fit: BoxFit.cover,
                                    );
                                  } else {
                                    return Image.network(
                                      widget.posts![index],
                                      fit: BoxFit.cover,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),

                        ),
                        Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    SizedBox(height: 170),
                                    buildIndicator(),
                                  ],
                                ),
                              ],
                            ))
                      ],
                    ),
                  )
              )
          )
      ),
    );
  }

  Widget buildImage(String catImage, intIndex) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      color: Colors.grey,
      child: Image.asset(catImage, fit: BoxFit.cover),
    );
  }

  Widget buildIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: widget.posts!.length < 4 ? widget.posts!.length + 1 : widget.posts!.length,
      effect: JumpingDotEffect(
        dotWidth: 14,
        dotHeight: 14,
        activeDotColor: Colors.pink,
        dotColor: Colors.white,
      ),
    );
  }
}