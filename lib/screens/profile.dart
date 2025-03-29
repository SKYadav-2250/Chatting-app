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

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.user});

  final ChatUser user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _image;
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: md.height * .05),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: md.width * .22),
                  child: Stack(
                    children: [
                      _image != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(md.height * .5),

                            child: Image.file(
                              File(_image!),
                              // color: Colors.red,
                              height: md.height * .25, // Increased size
                              width: md.height * .25,
                              fit: BoxFit.cover,
                            ),
                          )
                          : ClipRRect(
                            borderRadius: BorderRadius.circular(md.height * .5),

                            child: CachedNetworkImage(
                              // color: Colors.red,
                              height: md.height * .25, // Increased size
                              width: md.height * .25,
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

                      Positioned(
                        // left: 80,
                        right: 18,
                        // top: 80,
                        bottom: 20,

                        child: Container(
                          height: md.height * .05,
                          width: md.height * .05,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color.fromARGB(255, 229, 209, 234),
                          ),
                          child: IconButton(
                            onPressed: _showModelBottomSheet,
                            icon: Icon(Icons.camera_alt),
                          ),
                        ),
                      ),
                    ],
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

                SizedBox(height: md.height * .03),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: md.width * .05),
                  child: TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (newValue) {
                      if (newValue == null) {
                        return;
                      } else {
                        Apis.mySelf!.name = newValue;
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required field';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),

                      hintText: 'eg : user name',
                      label: Text('Name'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: md.height * .03),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: md.width * .05),
                  child: TextFormField(
                    onSaved: (newValue) {
                      if (newValue == null) {
                        return;
                      } else {
                        Apis.mySelf!.about = newValue;
                      }
                    },
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        return null;
                      }
                      return 'required field';
                    },

                    initialValue: widget.user.about,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.info_outline),

                      hintText: 'eg : About user',
                      label: Text('About'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: md.height * .03),

                ElevatedButton.icon(
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      _formkey.currentState!.save();
                      print('valid working');
                      await Apis.updateUserData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('User Detail Updated Successfully'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  ),

                  label: Text('Update'),
                  icon: Icon(Icons.edit),
                ),
                // Form(child:
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showModelBottomSheet() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: md.width * .10),
          color: Colors.white,
          height: md.height * .3,
          width: double.infinity,

          child: Column(
            children: [
              SizedBox(height: md.height * .02),

              Text(
                'Pick Profile Picture',
                style: TextStyle(
                  fontSize: 20,
                  color: const Color.fromARGB(255, 67, 6, 78),
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: md.height * .03),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (image != null) {
                        print('image   ${image.path}');
                        setState(() {
                          _image = image.path;
                        });
                        Apis.updateProfilePic(File(_image!));
                        Navigator.pop(context);
                      }
                      // Capture a photo.
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      fixedSize: Size(md.width * .3, md.height * .10),
                    ),

                    child: Image.asset('assets/images/gallery.png', height: 60),
                  ),

                  ElevatedButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.camera,
                      );
                      if (image != null) {
                        print('image   ${image.path}');
                        setState(() {
                          _image = image.path;
                        });
                        Apis.updateProfilePic(File(_image!));

                        Navigator.pop(context);
                      }
                      // Capture a photo.
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      fixedSize: Size(md.width * .3, md.height * .10),
                    ),
                    child: Image.asset('assets/images/camera.png', height: 60),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
