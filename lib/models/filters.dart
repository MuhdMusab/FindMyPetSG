import 'package:find_my_pet_sg/models/filter_model.dart';
import '../models/category.dart';
import '../models/post_type_model.dart';

class Filters {
  Filters();
  @override
  static List<Filter?> filters() {
    return
      [
        PostType(id: 1, postType: 'lost', value: false),
        PostType(id: 2, postType: 'found', value: false),
        Category(
          id: '1',
          name: 'Bird',
          description: 'This is a test description',
          imageUrl: 'assets/juice.png',
          index: 3,
          value: false,
        ),
        Category(
          id: '2',
          name: 'Cat',
          description: 'This is a test description',
          imageUrl: 'assets/pizza.png',
          index: 4,
          value: false,
        ),
        Category(
          id: '3',
          name: 'Chinchilla',
          description: 'This is a test description',
          imageUrl: 'assets/pizza.png',
          index: 5,
          value: false,
        ),
        Category(
          id: '4',
          name: 'Crab',
          description: 'This is a test description',
          imageUrl: 'assets/burger.png',
          index: 6,
          value: false,
        ),
        Category(
          id: '5',
          name: 'Dog',
          description: 'This is a test description',
          imageUrl: 'assets/pancake.png',
          index: 7,
          value: false,
        ),
        Category(
          id: '6',
          name: 'Frog',
          description: 'This is a test description',
          imageUrl: 'assets/avocado.png',
          index: 8,
          value: false,
        ),
        Category(
          id: '7',
          name: 'Gerbil',
          description: 'This is a test description',
          imageUrl: 'assets/avocado.png',
          index: 9,
          value: false,
        ),
        Category(
          id: '8',
          name: 'Guinea Pig',
          description: 'This is a test description',
          imageUrl: 'assets/avocado.png',
          index: 10,
          value: false,
        ),
        Category(
          id: '9',
          name: 'Hamster',
          description: 'This is a test description',
          imageUrl: 'assets/avocado.png',
          index: 11,
          value: false,
        ),
        Category(
          id: '10',
          name: 'Mouse',
          description: 'This is a test description',
          imageUrl: 'assets/avocado.png',
          index: 12,
          value: false,
        ),
        Category(
          id: '11',
          name: 'Rabbit',
          description: 'This is a test description',
          imageUrl: 'assets/avocado.png',
          index: 13,
          value: false,
        ),
        Category(
          id: '12',
          name: 'Tortoise',
          description: 'This is a test description',
          imageUrl: 'assets/avocado.png',
          index: 14,
          value: false,
        ),
        Category(
          id: '13',
          name: 'Turtle',
          description: 'This is a test description',
          imageUrl: 'assets/avocado.png',
          index: 15,
          value: false,
        ),
        Category(
          id: '14',
          name: 'Others',
          description: 'This is a test description',
          imageUrl: 'assets/avocado.png',
          index: 16,
          value: false,
        ),
      ];
  }
}