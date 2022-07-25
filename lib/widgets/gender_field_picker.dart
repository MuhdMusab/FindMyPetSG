import 'package:flutter/material.dart';

class GenderFieldPicker extends StatefulWidget {
  bool isMale;
  final Function setGender;

  GenderFieldPicker({
    Key? key,
    required this.isMale,
    required this.setGender,
  }) : super(key: key);

  @override
  State<GenderFieldPicker> createState() => _GenderFieldPickerState();
}

class _GenderFieldPickerState extends State<GenderFieldPicker> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, bottom: 12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Gender*",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey
                ),
              ),
            ],
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    widget.isMale = false;
                    widget.setGender(widget.isMale);
                  });
                },
                child: Container(
                  height: 51,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // color: isMale ? Colors.transparent : Colors.pink,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                        width: 2.0,
                        color: widget.isMale
                            ? Colors.black12
                            : Colors.pink),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Female",
                          style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                        ),
                        Icon(
                          Icons.female,
                          color: Colors.red,
                        )
                      ]),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    widget.isMale = true;
                    widget.setGender(widget.isMale);
                  });
                },
                child: Container(
                  height: 51,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                        width: 2.0,
                        color: widget.isMale
                            ? Colors.pink
                            : Colors.black12),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Male",
                          style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                        ),
                        Icon(
                          Icons.male,
                          color: Colors.blue,
                        )
                      ]),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

