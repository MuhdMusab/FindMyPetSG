import 'package:find_my_pet_sg/config/constants.dart';
import 'package:find_my_pet_sg/models/filter_model.dart';
import 'package:find_my_pet_sg/models/filters.dart';
import 'package:find_my_pet_sg/models/category.dart';
import 'package:find_my_pet_sg/models/post_type_model.dart';
import 'package:find_my_pet_sg/widgets/post_type_button.dart';
import 'package:find_my_pet_sg/widgets/type_of_animal_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterScreen extends StatefulWidget {
  final Function callback;

  const FilterScreen({
    Key? key,
    required this.callback,
  }) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  bool allSelected = false;
  List<Filter?> filters = Filters.filters();

  @override
  Widget build(BuildContext context) {
    callback(int index) {
      Object filterObject = filters[index]!;
      if (filterObject is PostType) {
        (filterObject as PostType).value = !(filterObject as PostType).value;
      } else {
        (filterObject as Category).value = !(filterObject as Category).value;
      }
    }
    return Scaffold(
      backgroundColor: Color(0xFFf6f6f6),
      appBar: AppBar(title: Text('Filter')),
      bottomNavigationBar: BottomAppBar(
        child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    shape: RoundedRectangleBorder(),
                    primary: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Text('Apply'),
                  onPressed: () {
                    widget.callback(filters);
                    Navigator.pop(context, true);
                  },
                ),

              ],
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Post Type',
              style: TextStyle(
                color: pink(),
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: 'Futura',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PostTypeButton(index: 0, text: "Lost", callback: callback,),
                  PostTypeButton(index: 1, text: "Found", callback: callback,),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Category',
                  style: TextStyle(
                    color: pink(),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'Futura',
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        allSelected = !allSelected;
                      });
                    },
                    child: Text(
                        'Select All'
                    )
                )
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  Column(
                    children: [
                      TypeOfAnimalButton(index: 2, text: 'Bird', callback: callback, allSelected: allSelected),
                      TypeOfAnimalButton(index: 3, text: 'Cat', callback: callback, allSelected: allSelected),
                      TypeOfAnimalButton(index: 4, text: 'Chinchilla', callback: callback, allSelected: allSelected),
                      TypeOfAnimalButton(index: 5, text: 'Crab', callback: callback, allSelected: allSelected),
                      TypeOfAnimalButton(index: 6, text: 'Dog', callback: callback, allSelected: allSelected),
                      TypeOfAnimalButton(index: 7, text: 'Frog', callback: callback, allSelected: allSelected),
                      TypeOfAnimalButton(index: 8, text: 'Gerbil', callback: callback, allSelected: allSelected),
                      TypeOfAnimalButton(index: 9, text: 'Guinea pig', callback: callback, allSelected: allSelected),
                      TypeOfAnimalButton(index: 10, text: 'Hamster', callback: callback, allSelected: allSelected),
                      TypeOfAnimalButton(index: 11, text: 'Mouse', callback: callback, allSelected: allSelected),
                      TypeOfAnimalButton(index: 12, text: 'Rabbit', callback: callback, allSelected: allSelected),
                      TypeOfAnimalButton(index: 13, text: 'Tortoise', callback: callback, allSelected: allSelected),
                      TypeOfAnimalButton(index: 14, text: 'Turtle', callback: callback, allSelected: allSelected),
                      TypeOfAnimalButton(index: 15, text: 'Others', callback: callback, allSelected: allSelected),
                    ],
                  ),

                ],),
            )
          ],
        ),
      ),
    );
  }
}
