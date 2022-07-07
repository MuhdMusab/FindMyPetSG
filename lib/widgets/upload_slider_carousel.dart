import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/pickImage.dart';

class UploadSliderCarousel extends StatefulWidget {
  //final imageArray;
  final Function? setImageCallback;

  const UploadSliderCarousel({
    Key? key,
    required this.setImageCallback,
  }) : super(key: key);

  //const UploadSliderCarousel({Key? key, required this.imageArray})
  //    : super(key: key);
  @override
  State<UploadSliderCarousel> createState() => _UploadSliderCarouselState();
}

class _UploadSliderCarouselState extends State<UploadSliderCarousel> with AutomaticKeepAliveClientMixin<UploadSliderCarousel> {
  int activeIndex = 0;
  List<File> croppedFiles = [];
  @override
  bool get wantKeepAlive => true;

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
                  if (croppedFiles.length >= 4) {
                    //do nothing
                  } else {
                    Navigator.pop(context);
                    XFile? file = await ImagePicker.platform.getImageFromSource(
                        source: ImageSource.camera);
                    croppedFiles.add(await cropSquareImage(File(file!.path)));
                    widget.setImageCallback!(croppedFiles);
                  }
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  List<PickedFile>? files = await ImagePicker.platform.pickMultiImage();
                  for (PickedFile file in files!) {
                    if (croppedFiles.length >= 4) {
                      // do nothing
                    } else {
                      final File currentFile = File(file.path);
                      croppedFiles.add(await cropSquareImage(currentFile));
                    }
                  }
                  widget.setImageCallback!(croppedFiles);
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

  _editImage(BuildContext parentContext) async {
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
                  XFile? file = await ImagePicker.platform.getImageFromSource(
                      source: ImageSource.camera);
                  croppedFiles[activeIndex] = (await cropSquareImage(File(file!.path)));
                  widget.setImageCallback!(croppedFiles);
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.pop(context);
                  XFile? file = await ImagePicker.platform.getImageFromSource(
                      source: ImageSource.gallery);
                  croppedFiles[activeIndex] = (await cropSquareImage(File(file!.path)));
                  widget.setImageCallback!(croppedFiles);
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
    super.build(context);
    return Material(
        child: InkWell(
            customBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            splashColor: Colors.black12,
            onTap: () {
              if (activeIndex == croppedFiles.length) {
                _selectImage(context);
              } else {
                _editImage(context);
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
                              itemCount: croppedFiles.length < 4 ? croppedFiles.length + 1 : croppedFiles.length,
                              options: CarouselOptions(
                                enableInfiniteScroll: false,
                                viewportFraction: 1,
                                height: 200,
                                onPageChanged: (index, reason) =>
                                    setState(() => activeIndex = index),

                              ),
                              itemBuilder: (context, index, realIndex) {
                                // final ImageInCarousel = widget.imageArray[index];
                                if (index == croppedFiles.length && croppedFiles.length < 4) {
                                  return Image.asset(
                                    "assets/images/uploadcameraimage.png",
                                    fit: BoxFit.cover,
                                  );
                                } else {
                                  return Image.file(
                                    croppedFiles[index],
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
      count: croppedFiles.length < 4 ? croppedFiles.length + 1 : croppedFiles.length,
      effect: JumpingDotEffect(
        dotWidth: 14,
        dotHeight: 14,
        activeDotColor: Colors.pink,
        dotColor: Colors.white,
      ),
    );
  }
}