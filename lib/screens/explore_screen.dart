import 'package:find_my_pet_sg/config/constants.dart';
import 'package:find_my_pet_sg/models/filter_model.dart';
import 'package:find_my_pet_sg/models/post_type_model.dart';
import 'package:find_my_pet_sg/services/notification_service.dart';
import 'package:find_my_pet_sg/widgets/custom_dialog_box.dart';
import 'package:find_my_pet_sg/widgets/full_posts.dart';
import 'package:find_my_pet_sg/widgets/widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_pet_sg/models/filter_model.dart';
import 'package:find_my_pet_sg/models/category.dart';
import '../widgets/lost_pet_post.dart';
import '../widgets/found_pet_post.dart';
import '../widgets/search_textfield.dart';
import 'create_lost_post_screen.dart';

const TextStyle _textStyle = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.bold,
  letterSpacing: 2,
  fontStyle: FontStyle.italic,
);

int _selectedPageIndex = 0;
List<Widget>? _pages;
PageController? _pageController;

class ExploreScreen extends StatefulWidget {
  QueryDocumentSnapshot<Object?>? _user;

  ExploreScreen(QueryDocumentSnapshot<Object?>? user) {
    this._user = user;
  }

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with AutomaticKeepAliveClientMixin<ExploreScreen> {
  @override
  bool get wantKeepAlive => true;

  void initState() {
    super.initState();
    _activateListeners();
  }

  void _activateListeners() {
    final String username = widget._user!['name'].toString();
    FirebaseDatabase.instance.ref().child(username).onChildChanged.listen((event) {
      //final String message = event.snapshot.value as String;
      //NotificationService().showNotification(1, "new message ", message, 2);
    });
  }
  List<Filter?> filters = [];

  _callback(List<Filter?> newFilters) {
    filters = newFilters;
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: pink(),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomDialogBox(
                    title: "Have you Lost or Found a pet?",
                    text: "yes",
                    user: widget._user);
              });
        },
        child: new Icon(
          Icons.add,
          size: 40.0,
          color: Colors.white,
        ),
        elevation: 8.0,
      ),
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 12, top: 18, bottom: 10),
              child: SearchTextField(callback: _callback),
            ),
          ),
          Divider(
            height: 1,
            thickness: 2,
            color: Colors.white,
          ),
          FullPosts(user: widget._user, filters: filters),
        ],
      ),
    );
    // )
  }
}
