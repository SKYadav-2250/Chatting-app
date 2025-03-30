// import 'dart:nativewrappers/_internal/vm/lib/developer.dart';
import 'dart:developer' as dev;
// import 'dart:nativewrappers/_internal/vm/lib/developer.dart';

import 'package:chatting_app/api/api.dart';
import 'package:chatting_app/main.dart';
import 'package:chatting_app/models/chat_user.dart';
import 'package:chatting_app/screens/auth_screen.dart/login_screen.dart';
import 'package:chatting_app/screens/profile.dart';
import 'package:chatting_app/widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> _list = [];


  
Future<void> fetchData() async {
  // Reference to the 'users' collection
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  try {
    // Fetch all documents in the collection
    QuerySnapshot querySnapshot = await users.get();

    // Iterate over the documents and access data
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      print('User Name: ${data['name']}');
      print('User Email: ${data['email']}');
      // Access other fields as needed
    }
  } catch (e) {
    print('Error fetching data: $e');
  }
}
  final List<ChatUser> _searchList = [];
  bool _isSearch = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
         Apis.getSelfInfo();

    
              dev.log( 'apis.getAllusers :  ${Apis.getAllUsers()}');

  

  
    SystemChannels.lifecycle.setMessageHandler((handler) {
      dev.log('message: ${handler.toString()}');
      if (Apis.auth.currentUser != null) {
        if (handler.toString().contains('resume')) {
          Apis.updateOnlineStatus(true);
        }
        if (handler.toString().contains('pause')) {
          Apis.updateOnlineStatus(false);
        }
      }
      return Future.value(handler);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: !_isSearch,
        onPopInvokedWithResult: (didPop, result) {
          if (_isSearch) {
            setState(() {
              dev.log( 'apis.getAllusers :  ${Apis.getAllUsers()}');
              _isSearch = false;
              _searchController.clear();
              _searchList.clear();
            });
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child:
                  _isSearch
                      ? TextField(
                        key: ValueKey(1),
                        controller: _searchController,
                        autofocus: true, // Focus when search opens
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: md.height * .01,
                            horizontal: md.width * .25,
                          ), // R
                          hintText: "Search...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchList.clear();
                            // _searchList.addAll(list.where((user) =>
                            //     user.name!.toLowerCase().contains(value.toLowerCase())));
                            for (var i in _list) {
                              if (i.name!.toLowerCase().contains(
                                    value.toLowerCase(),
                                  ) ||
                                  i.email!.toLowerCase().contains(
                                    value.toLowerCase(),
                                  )) {
                                _searchList.add(i);
                              }

                              setState(() {
                                _searchList;
                              });
                            }
                          });
                        },
                      )
                      : Text(
                        'Home',
                        key: ValueKey(2),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
            ),
            actions: [
              IconButton(
                icon: Icon(_isSearch ? Icons.close : Icons.search),
                onPressed: () {
                  setState(() {
                    _isSearch = !_isSearch;
                    _searchController.clear(); // Clear text when search closes
                  });
                },
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.camera)),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(user: Apis.mySelf!),
                    ),
                  );
                },
                icon: Icon(Icons.more_vert),
              ),
            ],
          ),

          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await Apis.auth.signOut();
              await GoogleSignIn().signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: const Icon(Icons.add),
          ),

          body: StreamBuilder(
            stream:  _isSearch? Apis.getAllUsers():Apis.getChattedusers(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());

                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs ?? [];

                  _list =
                      data
                          .map((element) => ChatUser.fromJson(element.data()))
                          .toList();

                  if (_list.isNotEmpty) {
                    return ListView.builder(
                      itemCount: _isSearch ? _searchList.length : _list.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ChatUserCard(
                          user: _isSearch ? _searchList[index] : _list[index],
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text(
                        'No users found',
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
