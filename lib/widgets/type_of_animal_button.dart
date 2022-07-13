import 'package:flutter/material.dart';

class TypeOfAnimalButton extends StatefulWidget {
  final int index;
  final String text;
  final Function callback;
  bool allSelected;

  TypeOfAnimalButton({
    Key? key,
    required this.index,
    required this.text,
    required this.callback,
    required this.allSelected,
  }) : super(key: key);

  @override
  State<TypeOfAnimalButton> createState() => _TypeOfAnimalButtonState();
}

class _TypeOfAnimalButtonState extends State<TypeOfAnimalButton> {
  @override
  Widget build(BuildContext context) {
    if (widget.allSelected) {
        widget.callback(widget.index, true);
    } else {
      widget.callback(widget.index, false);
    }
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 10,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.text,
            style: TextStyle(
              fontFamily: 'Futura',
              color: Color(0xFF2b2e4a),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          SizedBox(
            height: 25,
            child: Checkbox(
              value: widget.allSelected,
              activeColor: Color(0xFFff9dab),
              onChanged: (bool? newValue) {
                setState(() {
                  widget.allSelected = !widget.allSelected;
                  widget.callback(widget.index, newValue!);
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
