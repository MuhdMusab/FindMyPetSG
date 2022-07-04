import 'package:equatable/equatable.dart';

class Filter<T> {
  final T id;
  bool value;

  Filter({
    required this.id,
    required this.value,
  });
}