import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_pet_sg/config/constants.dart';
import 'package:find_my_pet_sg/screens/filter_screen.dart';
import 'package:find_my_pet_sg/screens/maps_screen.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SearchTextField extends StatefulWidget {
  final Function callback;
  final QueryDocumentSnapshot<Object?>? user;

  const SearchTextField({
    Key? key,
    required this.callback,
    required this.user,
  }) : super(key: key);

  @override
  State<SearchTextField> createState() => SearchTextfield();
}

class SearchTextfield extends State<SearchTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 16, bottom: 1),
              child: MaterialButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minWidth: 10,
                height: 34.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(color: pink()),
                ),
                color: Colors.white,
                child: Row(
                  children: [
                    Text(
                      "Map",
                      style: TextStyle(
                        fontFamily: 'Futura',
                        color: pink(),
                        fontWeight: FontWeight.bold,
                        fontSize:20,
                      ),
                    ),
                    Icon(MdiIcons.mapMarker, color: pink()),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return MapsScreen(user: widget.user);
                      }));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 16, bottom: 1),
              child: MaterialButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minWidth: 10,
                height: 34.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(color: pink()),
                ),
                color: pink(),
                child: Row(
                  children: [
                    Text("Filter ", style: TextStyle(
                      fontFamily: 'Futura',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:20,
                    ),
                    ),
                    Icon(Icons.tune, color: Colors.white),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return FilterScreen(callback: widget.callback);
                      }));
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}