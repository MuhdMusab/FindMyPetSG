import 'package:flutter/material.dart';

Color pink() {
  return Color(0xFFf26579);
}

Color lightPink() {
  return Color(0xFFffc4d4);
}

int userNameCharacterLimit = 20;
int petNameCharacterLimit = 15;
int ageCharacterLimit = 3;
int rewardCharacterLimit = 6;
int descriptionCharacterLimit = 300;

Color lostTextColor() {
  return Colors.white;
}

Color lostBoxColor() {
  return pink();
}

Color foundTextColor() {
  return Colors.white;
}

Color foundBoxColor() {
  return Colors.orange;
}
