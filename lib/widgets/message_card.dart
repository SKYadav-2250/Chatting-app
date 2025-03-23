import 'package:chatting_app/api/api.dart';
import 'package:chatting_app/models/message.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatting_app/main.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message });

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Apis.user.uid==widget.message.fromId?_greenMessage():_blueMessage();
  }

  Widget _blueMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,


      children: [
        Flexible(
          child: Container(
            padding:  EdgeInsets.all(md.width*.02),
            margin: EdgeInsets.symmetric(horizontal: md.width*.04,vertical: md.width*.04),
          
            decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topRight:Radius.circular(20),topLeft: Radius.circular(20),bottomRight: Radius.circular(20) ),
              color: const Color.fromARGB(255, 171, 199, 246),
              border: Border.all(color: const Color.fromARGB(255, 85, 139, 248))
          
            ),
            child: Text(widget.message.msg,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
          
          
          
          ),
        ),
       

        Padding(
          padding:  EdgeInsets.only(right: md.width*.03),
          child: Text(widget.message.sent,style: TextStyle(fontSize: 13, color: Colors.black54),),
        )
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
            SizedBox(width: md.width*.04,),
            Icon(Icons.done_all_rounded,color: Colors.blue,size: 20,),

     
        Text(widget.message.sent,style: TextStyle(fontSize: 12, color: Colors.black54),),
        
            
          ],
        ),
        
     
         Flexible(
           child: Container(
            
            padding:  EdgeInsets.all(md.width*.02),
            margin: EdgeInsets.symmetric(horizontal: md.width*.04,vertical: md.width*.04),
            decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomLeft: Radius.circular(20),topLeft: Radius.circular(20) ),
              border: Border.all(color: const Color.fromARGB(255, 84, 252, 90)),
           
           
            
           
              color: const Color.fromARGB(255, 194, 251, 196),
            ),
            child: Text(widget.message.msg,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
           
           
           
           
               ),
         ),
       ],
     );
  }
}
