import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:find_my_pet_sg/services/database.dart';
import 'package:find_my_pet_sg/services/storage_methods.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/pickImage.dart';

class OwnSliderCarousel extends StatefulWidget {
  //final imageArray;
  final int postIndex;
  final String username;
  List<dynamic>? posts;
  Function callback;
  final String postId;

  OwnSliderCarousel({
    Key? key,
    required this.postIndex,
    required this.username,
    required this.posts,
    required this.callback,
    required this.postId,
  }) : super(key: key);

  @override
  State<OwnSliderCarousel> createState() => _OwnSliderCarouselState();
}

class _OwnSliderCarouselState extends State<OwnSliderCarousel> {
  int activeIndex = 0;

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
                    await DatabaseMethods.addImageToPost(widget.username, widget.postId, urls[0],);
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
                        source: ImageSource.gallery);
                    File file = (await cropSquareImage(File(xfile!.path)));
                    final StorageMethods storageMethods = StorageMethods();
                    List<String> urls = await storageMethods.uploadImageToStorage('posts', file.readAsBytesSync());
                    await DatabaseMethods.addImageToPost(widget.username, widget.postId, urls[0],);
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
                  await DatabaseMethods.editPostAtIndex(widget.username, widget.postId, urls[0], activeIndex);
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
                  await DatabaseMethods.editPostAtIndex(widget.username, widget.postId, urls[0], activeIndex);
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
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress)
          return false;
        else
          return true;
      },
      child: Material(
          child: InkWell(
              customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),),
              splashColor: Colors.black12,
              onTap: () {
                if (activeIndex == widget.posts!.length) {
                  _selectImage(context, widget.postIndex);
                } else {
                  _editImage(context, widget.postIndex, activeIndex);
                }
              },
              child: Container(
                  width: 400,
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
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0)),
                    child: Stack(
                      children: [
                        Container(
                          width: 400,
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