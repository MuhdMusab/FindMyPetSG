import 'package:find_my_pet_sg/views/sign_up.dart';
import 'package:find_my_pet_sg/views/sign_up_form_screen.dart';
import 'package:find_my_pet_sg/widgets/widget.dart';
import 'package:flutter/material.dart';

const TextStyle _textStyle = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.bold,
  letterSpacing: 2,
  fontStyle: FontStyle.italic,
);

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _currentIndex = 0;
  List<Widget> pages = const [
    Text("Pets", style: _textStyle,),
    Text("Messages", style: _textStyle,),
    Text("Profile", style: _textStyle,),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      // body: Navigator(
      //   onGenerateRoute: (settings) {
      //     Widget page = _currentIndex == 0 ? widget
      //                                      : _currentIndex == 1
      //                                      ? SignUpForm()
      //                                      : SignUpForm();
      //     return MaterialPageRoute(builder: (_) => page);
      //   },
      // ),
      body: Container(
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.grey.withOpacity(0.5),
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        child: NavigationBar(
          backgroundColor: Colors.white,
          animationDuration: const Duration(seconds: 1),
          selectedIndex: _currentIndex,
          onDestinationSelected: (newIndex) {
            setState(() {
              _currentIndex = newIndex;
            });
          },
          destinations: [
            NavigationDestination(
                selectedIcon: Icon(Icons.abc, color: Color(0xfff26579),),
                icon: Icon(Icons.abc_outlined, color: Color(0xfff26579),),
                label: "Pets"
            ),
            NavigationDestination(
                selectedIcon: Icon(Icons.abc, color: Color(0xfff26579),),
                icon: Icon(Icons.abc_outlined, color: Color(0xfff26579),),
                label: "Messages"
            ),
            NavigationDestination(
                selectedIcon: Icon(Icons.account_circle, color: Color(0xfff26579),),
                icon: Icon(Icons.account_circle_outlined, color: Color(0xfff26579),),
                label: "Profile"
            ),
          ],
        ),
      ),
    );
  }
}
