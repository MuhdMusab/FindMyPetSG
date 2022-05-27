import 'package:find_my_pet_sg/views/chatRoomScreen.dart';
import 'package:find_my_pet_sg/views/profile_screen.dart';
import 'package:find_my_pet_sg/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
const TextStyle _textStyle = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.bold,
  letterSpacing: 2,
  fontStyle: FontStyle.italic,
);

int _selectedPageIndex = 0;
List<Widget> ? _pages;
PageController ? _pageController;



class ExploreScreen extends StatefulWidget {
  QueryDocumentSnapshot<Object?>? _user;

  ExploreScreen(QueryDocumentSnapshot<Object?>? user) {
    this._user = user;
  }

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();

}

class _ExploreScreenState extends State<ExploreScreen> with AutomaticKeepAliveClientMixin<ExploreScreen> {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: appBarMain(context),
    );
  }
}
