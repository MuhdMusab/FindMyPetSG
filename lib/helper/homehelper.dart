import 'package:flutter/foundation.dart';
import 'package:find_my_pet_sg/modal/messages.dart';

class HomeProvider extends ChangeNotifier {
  final List<Messages> _messages = [];

  List<Messages> get messages => _messages;

  addNewMessage(Messages message) {
    _messages.add(message);
    notifyListeners();
  }
}