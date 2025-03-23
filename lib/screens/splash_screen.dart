import 'package:chatting_app/api/api.dart';
import 'package:chatting_app/screens/auth_screen.dart/login_screen.dart';
import 'package:chatting_app/screens/home_screen.dart';


import 'package:flutter/material.dart';
import 'package:chatting_app/main.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1500), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(systemNavigationBarColor: Colors.white,statusBarColor:Colors.white),
      );

if(Apis.auth.currentUser!=null){

  
   
   Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
    
}else{


      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
}
    });
  }

  @override
  Widget build(BuildContext context) {
    md = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: md.height * .20,
            left: md.width * .25,
            width: md.width * .5,

            child: Image.asset('assets/images/whatsapp_image.png'),
          ),

          Positioned(
            bottom: md.height * .20,
            left: md.width * .30,

            height: md.height * .06,

            // padding: const EdgeInsets.all(8.0),
            child: Text(
              'MADE BY META ☠',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
