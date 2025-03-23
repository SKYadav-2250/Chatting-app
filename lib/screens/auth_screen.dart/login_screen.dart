import 'dart:developer';
import 'dart:io';

import 'package:chatting_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:chatting_app/main.dart';
import 'package:chatting_app/api/api.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatting_app/helper/dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void _handleSignIn() async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    Dialogs.showProgressbar(context);

    final user = await _signInWithGoogle();

    if (user != null) {
      Navigator.pop(context);
      log('\nUser:${user.user}');

      log('\nUserAdditinaldata:${user.additionalUserInfo}');

      if (await Apis.userExist()) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const HomeScreen();
            },
          ),
        );
      } else {
        await Apis.createUser().then((value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const HomeScreen();
              },
            ),
          );
        });
      }
    }
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await Apis.auth.signInWithCredential(credential);
    } catch (e) {
      print(e);

      log('_signInWithGoogle : $e');

      // throw Exception(e);
      Dialogs.showSnackbar(
        context,
        'something went wrong check intrenet connection',
      );
      Navigator.pop(context);

      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    md = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        title: const Text('welcome to we chat'),
        actions: [],
      ),

      body: Stack(
        children: [
          Positioned(
            top: md.height * .10,
            left: md.width * .25,
            width: md.width * .5,

            child: Image.asset('assets/images/whatsapp_image.png'),
          ),

          Positioned(
            bottom: md.height * .20,
            left: md.width * .20,
            width: md.width * .6,
            height: md.height * .06,

            // padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: _handleSignIn,

              // style: ButtonStyle(
              //   padding: WidgetStateProperty.all(const EdgeInsets.all(12)),

              // ),
              iconAlignment: IconAlignment.start,
              icon: Image.asset(
                'assets/images/whatsapp_image.png',
                height: 40,
                width: 40,
              ),
              label: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Sign',
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),

                    TextSpan(
                      text: ' With Google',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
