import 'package:flutter/material.dart';
// import 'package:fluttericon/fontelico_icons.dart';
// import 'package:fluttericon/typicons_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField({Key? key}) : super(key: key);

  @override
  State<SearchTextField> createState() => SearchTextfield();
}

class SearchTextfield extends State<SearchTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: TextField(
                cursorHeight: 20,
                cursorColor: Colors.pink,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 5),
                  filled: true,
                  fillColor: Colors.black12,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide:
                    BorderSide(color: Colors.transparent, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide:
                    BorderSide(color: Colors.transparent, width: 1.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide:
                    BorderSide(color: Colors.transparent, width: 1.0),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.black38, fontSize: 16.0),
                  prefixIcon: Padding(
                    padding:
                    const EdgeInsets.only(left: 2.0, top: 4.0, bottom: 2.0),
                    child: Icon(
                      Icons.search_outlined,
                      size: 26.0,
                      color: Colors.black38,
                    ),
                  ),
                  prefixIconConstraints: BoxConstraints(
                    maxHeight: 60,
                    maxWidth: 60,
                  ),
                ),
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
                  side: BorderSide(color: Colors.black26),
                ),
                color: Colors.white,
                child: Row(
                  children: [
                    Text("Filter ", style: TextStyle(color: Colors.black45)),
                    Icon(Icons.tune, color: Colors.black45),
                  ],
                ),
                onPressed: () => {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}