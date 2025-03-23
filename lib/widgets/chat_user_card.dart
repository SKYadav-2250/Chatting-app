import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting_app/main.dart';
import 'package:chatting_app/models/chat_user.dart';
import 'package:chatting_app/screens/chat_screen.dart';
import 'package:flutter/cupertino.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
// import 'package:chatting_app/api/api.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({super.key, required this.user});

  final ChatUser user;

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => ChatScreen(user:widget.user)));
      },
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        margin: const EdgeInsets.symmetric(vertical: 2),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(md.height * .3),

            child: CachedNetworkImage(
              height: md.height * .055, // Increased size
              width: md.height * .055,
              fit: BoxFit.cover,
              imageUrl: widget.user.image.toString(),

              placeholder:
                  (context, imageUrl) => const CircularProgressIndicator(),
              errorWidget:
                  (context, url, error) => const CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(CupertinoIcons.add),
                  ),
            ),
          ),

          title: Text(widget.user.name.toString(), maxLines: 1),
          subtitle: Text(widget.user.about.toString(), maxLines: 1),

          // trailing: Text(
          //   DateFormat(
          //     'hh:mm a',
          //   ).format(DateTime.now()), // Format time as hh:mm AM/PM
          // ),
          trailing: Container(
            height: 15,
            width: 15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
          ),
        ),
      ),
    );
  }
}
