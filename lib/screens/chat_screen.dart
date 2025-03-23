

import 'package:chatting_app/api/api.dart';
import 'package:chatting_app/models/chat_user.dart';
import 'package:chatting_app/models/message.dart';
import 'package:chatting_app/widgets/message_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:chatting_app/main.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.user});
  final ChatUser user;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  List<Message> list = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 229, 244, 255),
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: Container(
              color: Colors.grey, // Border color
              height: 1.0, // Border height
            ),
          ),
          bottomOpacity: 1,

          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),

        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: Apis.getAllMessages(widget.user),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(child: CircularProgressIndicator());
                      // return SizedBox();

                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;

                      list =
                          data
                              ?.map((e) => Message.fromJson(e.data()))
                              .toList() ??
                          [];
                   

                      if (list.isNotEmpty) {
                        return ListView.builder(
                          itemCount: list.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return MessageCard(message: list[index]);
                          },
                        );
                      } else {
                        return Center(
                          child: Text(
                            'Say hii...👋👋👋',
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      }
                  }
                },
              ),
            ),

            _chatInput(),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back),
          ),

          ClipRRect(
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
          SizedBox(width: 10),

          Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: md.height * .01),
              Text(
                widget.user.name.toString(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              Text(
                'Last seen : ${widget.user.lastActive}',
                style: TextStyle(
                  fontSize: 14,
                  color: const Color.fromARGB(255, 60, 66, 69),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.all(md.width * .025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(md.height * .03),
              ),

              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.emoji_emotions,
                      color: const Color.fromARGB(255, 120, 189, 245),
                    ),
                  ),

                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: 'Send a message...',

                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.camera_alt,
                      color: const Color.fromARGB(255, 120, 189, 245),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.image,
                      color: const Color.fromARGB(255, 120, 189, 245),
                    ),
                  ),

                  SizedBox(width: md.width * .02),
                ],
              ),
            ),
          ),

          MaterialButton(
            onPressed: () {
              if (_textEditingController.text.isNotEmpty) {
                Apis.sendMessage(widget.user, _textEditingController.text);
                _textEditingController.clear();
              }
            },
            minWidth: 1,
            shape: CircleBorder(),
            padding: const EdgeInsets.only(
              left: 10,
              right: 5,
              top: 10,
              bottom: 10,
            ),
            color: Colors.green,
            child: Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
