import 'package:flutter/material.dart';
import 'dart:math';
import 'package:find_my_pet_sg/services/storage_service.dart';

class PopupIcon extends StatefulWidget {
  IconData? icon;
  Color? color;
  String? text;
  Storage? storage;

  PopupIcon({
    Key? key,
    this.icon,
    this.color,
    this.text,
    this.storage,
  }) : super(key: key);

  @override
  _PopupIconState createState() => _PopupIconState();
}

class _PopupIconState extends State<PopupIcon> {
  bool onIt = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      height: 140,
      width: 100,
      child: Center(
        child: Stack(
          children: [
            AnimatedOpacity(
              opacity: onIt ? 1.0 : 0.0,
              curve: onIt ? Curves.easeOutBack : Curves.easeIn,
              duration: Duration(milliseconds: 200),
              child: AnimatedAlign(
                curve: onIt ? Curves.easeOutBack : Curves.easeIn,
                alignment: onIt ? Alignment(0.0, -1.0) : Alignment(0.0, 0.0),
                duration: Duration(milliseconds: 200),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 45.0,
                      top: 30.0,
                      child: Transform(
                        transform: Matrix4.rotationZ(pi / 4),
                        alignment: FractionalOffset.center,
                        child: Container(
                          height: 10.0,
                          width: 10.0,
                          color: widget.color,
                        ),
                      ),
                    ),
                    Container(
                      height: 20.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: widget.color,
                      ),
                      child: Center(
                        child: Text(
                          widget.text!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              child: GestureDetector(
                onLongPress: () {
            setState(() {
              onIt = true;
            });
          },
                onLongPressCancel: () {
                  setState(() {
                    onIt = false;
                  });
                },
                  child: AnimatedContainer(
                    height: 10.0,
                    width: 10.0,
                    duration: Duration(milliseconds: 375),
                    decoration: BoxDecoration(
                      color: onIt ? widget.color : Colors.white,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: FutureBuilder(
                        future: widget.storage!.downloadURL(),
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                          if (snapshot.connectionState == ConnectionState.done &&
                              snapshot.hasData) {
                            return CircleAvatar(
                              backgroundImage: NetworkImage(snapshot.data!),
                            );
                          } else {
                            return CircleAvatar(
                              backgroundImage: AssetImage("assets/images/default_user_icon.png"),
                            );
                          }
                        }
                    ),
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}

// child: FutureBuilder(
// future: storage.downloadURL(),
// builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
// if (snapshot.connectionState == ConnectionState.done &&
// snapshot.hasData) {
// return CircleAvatar(
// radius: 24,
// backgroundImage: NetworkImage(snapshot.data!),
// );
// } else {
// return CircleAvatar(
// radius: 24,
// backgroundImage: AssetImage("assets/images/default_user_icon.png"),
// );
// }
// }
// ),