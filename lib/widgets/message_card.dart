import 'package:chatting_app/api/api.dart';
import 'package:chatting_app/helper/my_date_util.dart';
import 'package:chatting_app/models/message.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatting_app/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Apis.user.uid == widget.message.fromId
        ? _greenMessage()
        : _blueMessage();
  }

  Widget _blueMessage() {
    //update lastvread message if sender send the message

    if (widget.message.read.isEmpty) {
      Apis.updateMessageReadStatus(widget.message);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(md.width * .02),
            margin: EdgeInsets.symmetric(
              horizontal: md.width * .04,
              vertical: md.width * .04,
            ),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              color: const Color.fromARGB(255, 171, 199, 246),
              border: Border.all(
                color: const Color.fromARGB(255, 85, 139, 248),
              ),
            ),
            child: widget.message.type == MessageType.image
                ?  CachedNetworkImage(
                
              
                fit: BoxFit.cover,
                imageUrl: widget.message.msg,

                placeholder:
                    (context, imageUrl) => const CircularProgressIndicator(),
                errorWidget:
                    (context, url, error) => const Icon(Icons.image  , size: 70,)
                    
              )
                :
             Text(
              widget.message.msg,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.only(right: md.width * .03),
          child: Text(
            MyDateUtil.getFormattedDate(
              context: context,
              time: widget.message.sent,
            ),
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget _greenMessage() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(width: md.width * .04),

            if (widget.message.read.isNotEmpty)
              const Icon(Icons.done_all_rounded, color: Colors.blue, size: 20),

            SizedBox(width: 2),

            Text(
              MyDateUtil.getFormattedDate(
                context: context,
                time: widget.message.sent,
              ),
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),

        Flexible(
          child: Container(
            padding: EdgeInsets.all(md.width * .02),
            margin: EdgeInsets.symmetric(
              horizontal: md.width * .04,
              vertical: md.width * .04,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
              border: Border.all(color: const Color.fromARGB(255, 84, 252, 90)),

              color: const Color.fromARGB(255, 194, 251, 196),
            ),
            child: widget.message.type == MessageType.image
                ?  ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                           
                  fit: BoxFit.cover,
                  imageUrl: widget.message.msg,
                 
                  
                  placeholder:
                      (context, imageUrl) => const CircularProgressIndicator(),
                  errorWidget:
                      (context, url, error) => const Icon(Icons.image  , size: 70,)
                      
                                ),
                )
                : Text(
              widget.message.msg,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ],
    );
  }
}
