import 'package:find_my_pet_sg/models/filter_model.dart';

class PostType extends Filter {
  final int id;
  final String postType;
  bool value;

  PostType({
    required this.id,
    required this.postType,
    required this.value,
  }): super(id: id, value: value);

  @override
  List<Object?> get props => [id, postType, value];

  static List<PostType> postTypes = [
    PostType(id: 1, postType: 'Lost', value: false),
    PostType(id: 2, postType: 'Found', value: false),
  ];

  @override
  String toString() {
    return "PostType id: " + id.toString() + "PostType: " + postType + "value: " + value.toString();
  }
}