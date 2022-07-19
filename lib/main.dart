import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
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
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:google_api_availability/google_api_availability.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotificationService().initNotification();
  await initializeService();
  runApp(MyApp());
}


Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch
bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');

  return true;
}

void onStart(ServiceInstance service) async {
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
          ticker: 'ticker',);
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);
      flutterLocalNotificationsPlugin.show(
          rng.nextInt(100000), title, subtitle, platformChannelSpecifics,
          payload: 'item x');
    });
  }
  DartPluginRegistrant.ensureInitialized();


  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  if (service is AndroidServiceInstance) {
    service.setAsBackgroundService();
    service.setForegroundNotificationInfo(
      title: "Lookout Notification",
      content: "Service running in background",
    );
    service.on('lookout').listen((inputData) {
      if (inputData!.containsKey('location') && inputData.containsKey('name') && inputData['name'] != '') {
        scheduleNotification('New ${inputData['type']} ${inputData['breed']} post named ${inputData['name']}',
            '${(inputData['type'] as String)[0].toUpperCase() + (inputData['type'] as String).substring(1)} at ${inputData['location']}');
      } else if (inputData.containsKey('location') && inputData.containsKey('name') && inputData['name'] == '') {
        scheduleNotification('New ${inputData['type']} ${inputData['breed']} post',
            '${(inputData['type'] as String)[0].toUpperCase() + (inputData['type'] as String).substring(1)} at ${inputData['location']}');
      }
    });

    service.on('newMessage').listen((inputData) {
      if (inputData != null) {
        scheduleNotification('New message from ${inputData['otherUser']}',
            '${(inputData['text'])}');
      }
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // bring to foreground
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    service.invoke(
      'update',
      {
        'hello' : 'hello',
      },
    );
  });
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

