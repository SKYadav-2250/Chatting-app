
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting_app/api/api.dart';
import 'package:chatting_app/helper/my_date_util.dart';
import 'package:chatting_app/main.dart';
import 'package:chatting_app/models/chat_user.dart';
import 'package:chatting_app/models/message.dart';
import 'package:chatting_app/screens/chat_screen.dart';
import 'package:chatting_app/widgets/dialog.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({super.key, required this.user});

  final ChatUser user;

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  Message? message;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ChatScreen(user: widget.user)),
        );
      },
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        margin: const EdgeInsets.symmetric(vertical: 2),
        child: StreamBuilder(
          stream: Apis.getLastMessage(widget.user),
          builder: (context, snapshot) {
            // log(snapshot.data.toString());

            final data = snapshot.data?.docs;

            final list =
                data
                    ?.map((element) => Message.fromJson(element.data()))
                    .toList() ??
                [];

            if (list.isNotEmpty) {
              message = list[0];
            }

            // if(data!=null)
            return ListTile(
              leading: InkWell(
                onTap: (){
                  showDialog(context: context, builder: (_)=>ProfileDialog(user: widget.user,));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(md.height * .3),
                
                  child: CachedNetworkImage(
                    height: md.height * .055, // Increased size
                    width: md.height * .055,
                    fit: BoxFit.cover,
                    imageUrl: widget.user.image ?? '',
                
                    placeholder:
                        (context, imageUrl) => const CircularProgressIndicator(),
                    errorWidget:
                        (context, url, error) => const CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(CupertinoIcons.add),
                        ),
                  ),
                ),
              ),

              title: Text(widget.user.name.toString(), maxLines: 1),
              
             
              

  subtitle: message != null
      ? message!.type == MessageType.image
          ? Row(
              children: [
                const Icon(Icons.image, size: 18),
                const SizedBox(width: 5),
                const Text('Photo', overflow: TextOverflow.ellipsis),
              ],
            ) // ✅ Display an icon for image messages
          : Text(message!.msg, overflow: TextOverflow.ellipsis)
      : Text(widget.user.about.toString(), overflow: TextOverflow.ellipsis),

            

     
              trailing:
                  message == null
                      ? null
                      : message!.read.isEmpty
                      ? Container(
                        height: 15,
                        width: 15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                      )
                      : Text(
                        MyDateUtil.getLastMessageTime(
                          context: context,
                          time: message!.sent,
                        ),
                      ),
            );
          },
        ),
      ),
    );
  }
}
