// import 'dart:nativewrappers/_internal/vm/lib/math_patch.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting_app/api/api.dart';
import 'package:chatting_app/helper/dialog.dart';
import 'package:chatting_app/models/chat_user.dart';
import 'package:chatting_app/screens/auth_screen.dart/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatting_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ChatUserProfile extends StatefulWidget {
  const ChatUserProfile({super.key, required this.user});

  final ChatUser user;

  @override
  State<ChatUserProfile> createState() => _ChatUserProfileState();
}

class _ChatUserProfileState extends State<ChatUserProfile> {
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text('Profile'), elevation: 2),

        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            Dialogs.showProgressbar(context);
            await Apis.updateOnlineStatus(false);
            await Apis.auth.signOut().then((value) async {
              await GoogleSignIn().signOut().then((value) {
                Navigator.pop(context);
                Navigator.pop(context);
                Apis.auth = FirebaseAuth.instance;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              });
            });
          },
          label: Text('Sign out'),
          icon: Icon(Icons.logout),
        ),

        body: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: md.height * .05),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(md.height * .5),

                    child: CachedNetworkImage(
                      // color: Colors.red,
                      height: md.height * .15, // Increased size
                      width: md.height * .15,
                      fit: BoxFit.cover,
                      imageUrl: widget.user.image.toString(),

                      placeholder:
                          (context, imageUrl) =>
                              const CircularProgressIndicator(),
                      errorWidget:
                          (context, url, error) => const CircleAvatar(
                            backgroundColor: Colors.grey,
                            child: Icon(CupertinoIcons.add),
                          ),
                    ),
                  ),

                  SizedBox(height: md.height * .03),

                  Text(
                    widget.user.email.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: md.height * .05),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: md.width * .10),
                    padding:const EdgeInsets.all(8.0),
                   
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        style: BorderStyle.solid,
                    
                        color: Colors.black,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Name : ',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            )),
                        SizedBox(width: md.width * .02),
                        Text(
                          widget.user.name.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ],
                    ),
                  ),


                   Container(
                    margin: EdgeInsets.symmetric(horizontal: md.width * .10),
                    padding:const EdgeInsets.all(8.0),
                   
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        style: BorderStyle.solid,
                    
                        color: Colors.black,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Joiing Date : ',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            )),
                        SizedBox(width: md.width * .02),
                        Text(
                          widget.user.lastActive.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
