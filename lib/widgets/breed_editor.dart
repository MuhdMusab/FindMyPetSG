import 'package:find_my_pet_sg/widgets/animal_search_delegate.dart';
import 'package:flutter/material.dart';

class BreedEditor extends StatefulWidget {
  final Function setAnimalTypeCallback;
  TextEditingController breedController;

  BreedEditor({
    Key? key,
    required this.setAnimalTypeCallback,
    required this.breedController,
  }) : super(key: key);

  @override
  State<BreedEditor> createState() => _BreedEditorState();
}

class _BreedEditorState extends State<BreedEditor> {
  _callback(String animal) {
    setState(() {
      widget.breedController.text = animal;
      breedText = Positioned(
        top: 14,
        left: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            widget.breedController.text,
            style:
            TextStyle(fontSize: 16, color: Colors.blueGrey),
          ),
        ),
      );
      widget.setAnimalTypeCallback(animal);
    });
  }

  Positioned? breedText;

  void initState() {
    super.initState();
    breedText = Positioned(
      top: 14,
      left: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Text(
          widget.breedController.text,
          style:
          TextStyle(fontSize: 16, color: Colors.blueGrey),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Type of animal*",
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
                onTap: () => showSearch(
                    context: context,
                    delegate: AnimalSearchDelegate(
                        callback: widget.setAnimalTypeCallback,
                        callback2: _callback)),
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
                    breedText!,
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
