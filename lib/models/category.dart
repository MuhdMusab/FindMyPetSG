import 'package:equatable/equatable.dart';
import 'package:find_my_pet_sg/models/filter_model.dart';

class Category extends Filter<String> {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int index;
  bool value;

  // Category(String id, String name, String description, String imageUrl, int index, bool value) {
  //   super(id, value);
  // };
  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.index,
    required this.value,
  }) : super(id: id, value: value);

  @override
  List<Object?> get props => [id, name, description, imageUrl, index, value];

  factory Category.fromSnapshot(Map<String, dynamic> snap) {
    return Category(
      id: snap['id'].toString(),
      name: snap['name'],
      description: snap['description'],
      imageUrl: snap['imageUrl'],
      index: snap['index'],
      value: false,
    );
  }

  @override
  String toString() {
    return "Category id: " + id.toString() + "Category: " + name + "value: " + value.toString();
  }

  static List<Category> categories = [
    Category(
      id: '1',
      name: 'Bird',
      description: 'This is a test description',
      imageUrl: 'assets/juice.png',
      index: 0,
      value: false,
    ),
    Category(
      id: '2',
      name: 'Cat',
      description: 'This is a test description',
      imageUrl: 'assets/pizza.png',
      index: 1,
      value: false,
    ),
    Category(
      id: '3',
      name: 'Chinchilla',
      description: 'This is a test description',
      imageUrl: 'assets/pizza.png',
      index: 2,
      value: false,
    ),
    Category(
      id: '4',
      name: 'Crab',
      description: 'This is a test description',
      imageUrl: 'assets/burger.png',
      index: 3,
      value: false,
    ),
    Category(
      id: '5',
      name: 'Dog',
      description: 'This is a test description',
      imageUrl: 'assets/pancake.png',
      index: 4,
      value: false,
    ),
    Category(
      id: '6',
      name: 'Frog',
      description: 'This is a test description',
      imageUrl: 'assets/avocado.png',
      index: 5,
      value: false,
    ),
    Category(
      id: '7',
      name: 'Gerbil',
      description: 'This is a test description',
      imageUrl: 'assets/avocado.png',
      index: 6,
      value: false,
    ),
    Category(
      id: '8',
      name: 'Guinea Pig',
      description: 'This is a test description',
      imageUrl: 'assets/avocado.png',
      index: 7,
      value: false,
    ),
    Category(
      id: '9',
      name: 'Hamster',
      description: 'This is a test description',
      imageUrl: 'assets/avocado.png',
      index: 8,
      value: false,
    ),
    Category(
      id: '10',
      name: 'Mouse',
      description: 'This is a test description',
      imageUrl: 'assets/avocado.png',
      index: 9,
      value: false,
    ),
    Category(
      id: '11',
      name: 'Rabbit',
      description: 'This is a test description',
      imageUrl: 'assets/avocado.png',
      index: 10,
      value: false,
    ),
    Category(
      id: '12',
      name: 'Tortoise',
      description: 'This is a test description',
      imageUrl: 'assets/avocado.png',
      index: 11,
      value: false,
    ),
    Category(
      id: '13',
      name: 'Turtle',
      description: 'This is a test description',
      imageUrl: 'assets/avocado.png',
      index: 12,
      value: false,
    ),
    Category(
      id: '14',
      name: 'Others',
      description: 'This is a test description',
      imageUrl: 'assets/avocado.png',
      index: 13,
      value: false,
    ),
  ];
}