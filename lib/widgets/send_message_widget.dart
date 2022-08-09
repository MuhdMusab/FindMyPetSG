import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/pickImage.dart';

class SendMessageWidget extends StatefulWidget {
  Function? sendMessage;
  TextEditingController? textEditingController;
  Function? canSendMessage;
  ScrollController? scrollController;

  SendMessageWidget({
    Key? key,
    this.sendMessage,
    this.textEditingController,
    this.canSendMessage,
    this.scrollController,
  }) : super(key: key);

  @override
  State<SendMessageWidget> createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendMessageWidget> {
  bool _isImageAttached = false;
  File? fileToAttach;

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Share an image'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  XFile? xFile = await ImagePicker.platform
                      .getImageFromSource(source: ImageSource.camera);
                  fileToAttach = await cropRectangleImage(File(xFile!.path));
                  setState(() {
                    _isImageAttached = true;
                  });
                  //widget.setImageCallback!(croppedFiles);
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  XFile? xFile = await ImagePicker.platform
                      .getImageFromSource(source: ImageSource.gallery);
                  fileToAttach = await cropRectangleImage(File(xFile!.path));
                  setState(() {
                    _isImageAttached = true;
                  });
                  //widget.setImageCallback!(croppedFiles);
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            _selectImage(context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox.square(
              child: Icon(
                Icons.image,
                size: 30,
              ),
            ),
          ),
        ),
        Flexible(
          child: _isImageAttached
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        controller: widget.textEditingController,
                        onSubmitted: (input) {
                          _isImageAttached
                              ? widget.sendMessage!(fileToAttach)
                              : widget.sendMessage!(File('empty'));
                          setState(() {
                            _isImageAttached = false;
                            fileToAttach = null;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter new message',
                        ),
                      ),
                    ),
                    Image.file(fileToAttach!),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: widget.textEditingController,
                    onSubmitted: (input) {},
                    decoration: InputDecoration(
                      hintText: 'Enter new message',
                    ),
                  ),
                ),
        ),
        IconButton(
            icon: Icon(widget.canSendMessage!()
                ? CupertinoIcons.arrow_right_circle_fill
                : CupertinoIcons.arrow_right_circle),
            onPressed: () {
              _isImageAttached
                  ? widget.sendMessage!(fileToAttach)
                  : widget.sendMessage!(File('empty'));
              setState(() {
                _isImageAttached = false;
                fileToAttach = null;
              });
            })
      ],
    );
  }
}
