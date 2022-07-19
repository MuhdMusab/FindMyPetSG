import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_pet_sg/config/constants.dart';
import 'package:find_my_pet_sg/screens/chats_screen.dart';
import 'package:flutter/material.dart';
import 'package:find_my_pet_sg/screens/profile_screen.dart';
import 'package:find_my_pet_sg/screens/explore_screen.dart';
import '../helper/custom_icons_icons.dart';

class Home extends StatefulWidget {
  QueryDocumentSnapshot<Object?>? _user;

  Home(QueryDocumentSnapshot<Object?>? user) {
    this._user = user;
  }
  @override
  State<Home> createState() => _HomeState();
}



class _HomeState extends State<Home> {
  int _selectedPageIndex = 0;
  List<Widget> ? _pages;
  PageController ? _pageController;
  void initState() {
    super.initState();
    _selectedPageIndex = 0;
    _pages = [
      ExploreScreen(widget._user),
      SearchScreen(widget._user),
      ProfileScreen(widget._user),
    ];
    _pageController = PageController(initialPage: _selectedPageIndex);
    //_activateListeners();
  }

  // void _activateListeners() {
  //   final String username = widget._user!['name'].toString();
  //   FirebaseDatabase.instance.ref().child(username).onChildAdded.listen((event) {
  //     // final String message = event.snapshot.value as String;
  //     // NotificationService().showNotification(1, "new message ", message, 2);
  //   });
  // }


  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: _pages!,
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(
            color: Colors.black,
          ),
          unselectedLabelStyle: TextStyle(
            color: Colors.black,
          ),
          items: [
          BottomNavigationBarItem(
             activeIcon: Icon(CustomIcons.paw, color: pink()),
             icon: Icon(CustomIcons.paw, color: pink()),
           label: "Pets",
         ),
        BottomNavigationBarItem(
          activeIcon: Icon(CustomIcons.chat, color: pink()),
          icon: Icon(CustomIcons.chat, color: pink()),
          label: "Messages",
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.account_circle, color: pink()),
          icon: Icon(Icons.account_circle_outlined, color: pink()),
          label: "Profile",
        ),],
          currentIndex: _selectedPageIndex,
          onTap: (selectedPageIndex) {
            setState(() {
              _selectedPageIndex = selectedPageIndex;
              _pageController!.jumpToPage(selectedPageIndex);
            });
          },
        )
    );
  }
}
