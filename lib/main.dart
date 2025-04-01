
import 'dart:developer';

import 'package:chatting_app/screens/splash_screen.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/notification_importance.dart';

import 'firebase_options.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';


late Size md;

Future  main()async {
    await dotenv.load(fileName: ".env");


  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) {
    _initilizerApp();
   
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.red,

       
      ),
      home: SplashScreen(),
    );
  }
}

_initilizerApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  var result = await FlutterNotificationChannel().registerNotificationChannel(
    description: 'For showing message notification',
    id: 'chatting_app',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'chatting_app',

   
    
);
log('result :  $result');


}
