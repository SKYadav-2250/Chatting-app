import 'dart:developer';

import 'package:chatting_app/api/api.dart';
import 'package:chatting_app/helper/my_date_util.dart';
import 'package:chatting_app/models/chat_user.dart';
import 'package:chatting_app/models/message.dart';
import 'package:chatting_app/widgets/message_card.dart';

import 'package:chatting_app/screens/chat_user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:chatting_app/main.dart';
import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.user});
  final ChatUser user;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  bool _isUploading = false;

  bool _showEmoji = false;
  List<Message> list = [];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          if (_showEmoji) _showEmoji = false;
        });
      },
      child: PopScope(
        canPop: !_showEmoji,
        onPopInvokedWithResult: (didPop, result) {
          if (_showEmoji) {
            setState(() {
              _showEmoji = !_showEmoji;
            });
          }
        },
        child: SafeArea(
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
                    // initialData: ,
                    stream: Apis.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
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
                              reverse: true,
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
                if (_isUploading)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 40,
                      ),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),

                _chatInput(),
                if (_showEmoji)
                  EmojiPicker(
                    textEditingController:
                        _textEditingController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                    config: Config(
                      height: 320,

                      // bgColor: const Color(0xFFF2F2F2)\,
                      // bgColor: const Color.fromARGB(255, 229, 244, 255),
                      checkPlatformCompatibility: true,

                      emojiViewConfig: EmojiViewConfig(
                        // Issue: https://github.com/flutter/flutter/issues/28894
                        emojiSizeMax:
                            28 *
                            (foundation.defaultTargetPlatform ==
                                    TargetPlatform.iOS
                                ? 1.20
                                : 1.30),
                      ),

                      viewOrderConfig: const ViewOrderConfig(
                        bottom: EmojiPickerItem.searchBar,
                        middle: EmojiPickerItem.categoryBar,
                        top: EmojiPickerItem.emojiView,
                      ),
                      skinToneConfig: const SkinToneConfig(
                        dialogBackgroundColor: Color.fromARGB(255, 5, 109, 182),
                      ),
                      categoryViewConfig: const CategoryViewConfig(),
                      bottomActionBarConfig: const BottomActionBarConfig(),
                      searchViewConfig: const SearchViewConfig(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ChatUserProfile(user: widget.user)),
        );
      },

      child: StreamBuilder(
        stream: Apis.getUserInfo(widget.user),
        builder: (context, snapshot) {
          final data = snapshot.data?.docs;
          final list =
              data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

          for (var i in list) {
            log('list : ${i.name}');
          }

          return Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back, color: Colors.black),
              ),

              ClipRRect(
                borderRadius: BorderRadius.circular(md.height * .3),

                child: CachedNetworkImage(
                  height: md.height * .055, // Increased size
                  width: md.height * .055,
                  fit: BoxFit.cover,
                  imageUrl:
                      list.isNotEmpty
                          ? list[0].image.toString()
                          : widget.user.image.toString(),

                  placeholder:
                      (context, imageUrl) => const CircularProgressIndicator(),
                  errorWidget:
                      (context, url, error) => const CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(CupertinoIcons.add),
                      ),
                ),
              ),
              SizedBox(width: md.width * .025),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: md.width * .01),
                  Text(
                    list.isNotEmpty
                        ? list[0].name.toString()
                        : widget.user.name.toString(),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    ' ${list.isNotEmpty
                        ? list[0].isOnline!
                            ? 'Online'
                            : MyDateUtil.getLastActiveTime(context: context, lasttime: list[0].lastActive.toString())
                        : MyDateUtil.getLastActiveTime(context: context, lasttime: widget.user.lastActive.toString())}',

                    style: TextStyle(
                      fontSize: 14,
                      color: const Color.fromARGB(255, 60, 66, 69),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
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
                    onPressed: () {
                      setState(() {
                        FocusScope.of(context).unfocus();
                        _showEmoji = !_showEmoji;
                      });
                    },
                    icon: Icon(
                      Icons.emoji_emotions,
                      color: const Color.fromARGB(255, 120, 189, 245),
                    ),
                  ),

                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      maxLines: null,
                      keyboardAppearance: Brightness.dark,
                      keyboardType: TextInputType.multiline,
                      onTap: () {
                        setState(() {
                          _showEmoji = false;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Send a message...',

                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () async {
                      try {
                        final ImagePicker picker = ImagePicker();
                        final List<XFile> images = await picker.pickMultiImage(
                          // source: ImageSource.camera,
                          imageQuality: 50,
                        );

                        for (var image in images) {
                          log('image   ${image.path}');
                          setState(() {
                            _isUploading = true;
                          });
                          await Apis.sendChatImage(
                            widget.user,
                            File(image.path),
                          );
                          setState(() {
                            _isUploading = false;
                          });
                        }
                      } catch (e) {
                        log('error sending image : $e');
                        setState(() {
                          _isUploading = false;
                        });
                      }

                      // Capture a photo.
                    },
                    icon: Icon(
                      Icons.image,
                      color: const Color.fromARGB(255, 120, 189, 245),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      try {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(
                          imageQuality: 50,
                          source: ImageSource.camera,
                        );

                        if (image != null) {
                          setState(() {
                            _isUploading = true;
                          });

                          await Apis.sendChatImage(
                            widget.user,
                            File(image.path),
                          );
                          setState(() {
                            _isUploading = false;
                          });
                        }
                      } catch (e) {
                        log('error sending image : $e');
                        setState(() {
                          _isUploading = false;
                        });
                      }

                      // Capture a photo.
                    },
                    icon: Icon(
                      Icons.camera_alt,
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
                if (list.isEmpty) {
                  Apis.sendFirstMessage(
                    widget.user,
                    _textEditingController.text,
                    MessageType.text,
                  );
                  _textEditingController.clear();
                } else {
                  Apis.sendMessage(
                    widget.user,
                    _textEditingController.text,
                    MessageType.text,
                  );
                  _textEditingController.clear();
                }
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
