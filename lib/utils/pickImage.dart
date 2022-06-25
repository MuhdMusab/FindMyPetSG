import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';

// for picking up image from gallery
pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No Image Selected');
}

Future<File?> pickMedia({
  required bool isGallery,
  Future<File> Function(File file)? cropImage,
}) async {
  final source = isGallery ? ImageSource.gallery : ImageSource.camera;
  final pickedFile = await ImagePicker().pickImage(source: source); //getImage(source: source);

  if (pickedFile == null) return null;

  if (cropImage == null) {
    return File(pickedFile.path);
  } else {
    final file = File(pickedFile.path);

    return cropImage(file);
  }
}

Future<File> cropSquareImage(File imageFile) async =>
    File((await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 2, ratioY: 1),
      compressQuality: 70,
      compressFormat: ImageCompressFormat.jpg,
    ))!.path);

