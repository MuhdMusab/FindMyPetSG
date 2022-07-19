import 'dart:math';

import 'package:find_my_pet_sg/config/theme.dart';
import 'package:find_my_pet_sg/firebase_options.dart';
import 'package:find_my_pet_sg/helper/authenticate.dart';
import 'package:find_my_pet_sg/helper/google_sign_in_provider.dart';
import 'package:find_my_pet_sg/screens/main_page.dart';
import 'package:find_my_pet_sg/screens/verify_email_screen.dart';
import 'package:find_my_pet_sg/services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:google_api_availability/google_api_availability.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workmanager/workmanager.dart';


void callbackDispatcher() {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  new FlutterLocalNotificationsPlugin();
  void scheduleNotification(String title, String subtitle) {
    print("scheduling one with $title and $subtitle");
    var rng = new Random();
    Future.delayed(Duration(seconds: 5)).then((result) async {
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'your channel id', 'your channel name',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker');
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);
      flutterLocalNotificationsPlugin.show(
          rng.nextInt(100000), title, subtitle, platformChannelSpecifics,
          payload: 'item x');
    });
  }

  Workmanager().executeTask((taskName, inputData) {
    print('Task executing :' + taskName);
    print(inputData);
    if (inputData!.containsKey('location') && inputData.containsKey('name')) {
      print('post has been scheduled with name');
      scheduleNotification('New ${inputData['type']} ${inputData['breed']} post named ${inputData['name']}',
          '${(inputData['type'] as String)[0].toUpperCase() + (inputData['type'] as String).substring(1)} at ${inputData['location']}');
      scheduleNotification('case 1', 'hello');
    } else if (inputData.containsKey('location')) {
      print('post has been scheduled without name');
      scheduleNotification('New ${inputData['type']} ${inputData['breed']} post',
          '${(inputData['type'] as String)[0].toUpperCase() + (inputData['type'] as String).substring(1)} at ${inputData['location']}');
      scheduleNotification('case 2', 'hello');
    }
    scheduleNotification('case 3', 'hello');
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher);
  NotificationService().initNotification();
  await Firebase.initializeApp();
  //GoogleApiAvailability.instance.checkGooglePlayServicesAvailability();
  // FirebaseAppCheck firebaseAppCheck = FirebaseAppCheck.getInstance();
  // firebaseAppCheck.installAppCheckProviderFactory(
  //     PlayIntegrityAppCheckProviderFactory.getInstance());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const MaterialColor white =
      const MaterialColor(0xFFFFFFFF, const <int, Color>{
    50: const Color(0xFFFFFFFF),
    100: const Color(0xFFFFFFFF),
    200: const Color(0xFFFFFFFF),
    300: const Color(0xFFFFFFFF),
    400: const Color(0xFFFFFFFF),
    500: const Color(0xFFFFFFFF),
    600: const Color(0xFFFFFFFF),
    700: const Color(0xFFFFFFFF),
    800: const Color(0xFFFFFFFF),
    900: const Color(0xFFFFFFFF),
  });
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: theme(),
        home: MainPage(),
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold();
}
