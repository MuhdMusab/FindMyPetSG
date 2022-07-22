import 'package:flutter/material.dart';

class DateFieldPicker extends StatefulWidget {
  final TextEditingController dateController;

  DateFieldPicker({
    Key? key,
    required this.dateController,
  }) : super(key: key);

  @override
  State<DateFieldPicker> createState() => _DateFieldPickerState();
}

class _DateFieldPickerState extends State<DateFieldPicker> {
  @override
  Widget build(BuildContext context) {
    void _showDatePicker() {
      showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.pink,
              ),
            ),
            child: child!,
          );
        },
      ).then((value) {
        if (value != null) {
          setState(() {
            widget.dateController.text = value.day.toString() +
                "/" +
                value.month.toString() +
                "/" +
                value.year.toString();
          });
        }
      });
    }

    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Date*",
            style: TextStyle(fontSize: 16, color: Colors.blueGrey),
          ),
          Container(
            height: 51,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey.shade200),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(4.0),
                onTap: _showDatePicker,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: Colors.transparent,
                      ),
                      height: 30,
                      width: 370,
                    ),
                    Positioned(
                      top: 14,
                      left: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          widget.dateController.text,
                          style:
                              TextStyle(fontSize: 16, color: Colors.blueGrey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
