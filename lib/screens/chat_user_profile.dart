import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting_app/helper/my_date_util.dart';
import 'package:chatting_app/models/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:chatting_app/main.dart';

class ChatUserProfile extends StatefulWidget {
  const ChatUserProfile({super.key, required this.user});
  final ChatUser user;

  @override
  State<ChatUserProfile> createState() => _ChatUserProfileState();
}

class _ChatUserProfileState extends State<ChatUserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, elevation: 1, title: Text('Profile')),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Joined On : ',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          Text(
            MyDateUtil.getLastMessageTime(
              context: context,
              time: widget.user.createdAt.toString(),
              showYear: true,
            ),
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: md.height * .05),

            ClipRRect(
              borderRadius: BorderRadius.circular(md.height * .1),
              child: CachedNetworkImage(
                width: md.height * .20,
                height: md.height * .20,
                fit: BoxFit.cover,
                imageUrl: widget.user.image.toString(),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),

            SizedBox(height: md.height * .05),
            Text(
              widget.user.name.toString(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: md.height * .05),
            Text(widget.user.email.toString(), style: TextStyle(fontSize: 18)),
            SizedBox(height: md.height * .05),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'About: ',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                Text(
                  widget.user.about.toString(),
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),

            SizedBox(height: md.height * .10),
          ],
        ),
      ),
    );
  }
}
