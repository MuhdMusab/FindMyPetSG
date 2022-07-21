// import 'dart:math';
//
// import 'package:animated_toggle_switch/animated_toggle_switch.dart';
// import 'package:flutter/material.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
//
// import '../config/constants.dart';
//
// //
// class ToggleViewButton extends StatefulWidget {
//   PageController pageController;
//   ToggleViewButton({Key? key, required this.pageController}) : super(key: key);
//
//   @override
//   State<ToggleViewButton> createState() => _ToggleViewButtonState();
// }
//
// class _ToggleViewButtonState extends State<ToggleViewButton> {
//   int value = 0;
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       top: 14,
//       right: 10,
//       child: Container(
//           height: 40,
//           child: AnimatedToggleSwitch<int>.size(
//               current: value,
//               values: [0, 1],
//               indicatorBorderRadius: BorderRadius.zero,
//               borderWidth: 1.0,
//               borderRadius: BorderRadius.circular(8.0),
//               iconOpacity: 0.2,
//               indicatorSize: Size.fromWidth(60),
//               iconSize: const Size.square(40),
//               iconBuilder: (value, size) {
//                 IconData data = MdiIcons.mapMarker;
//                 if (value.isEven) data = Icons.list;
//                 return Icon(
//                   data,
//                   size: min(size.width, size.height),
//                   color: Colors.pink,
//                 );
//               },
//               borderColor: lightPink(),
//               colorBuilder: (i) => i.isEven ? lightPink() : lightPink(),
//               onChanged: (i) {
//                 if (i == 0) {
//                   pageController.jumpToPage(0);
//                 } else if (i == 1 &&
//                     isPrecise == true &&
//                     userPosition != null) {
//                   pageController.jumpToPage(1);
//                 } else {
//                   pageController.jumpToPage(3);
//                 }
//               })),
//     );
//   }
// }
