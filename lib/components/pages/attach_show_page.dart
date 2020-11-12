import 'dart:io';

import 'package:flutter/material.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/container_row.dart';
import 'package:live_chat/components/common/image_widget.dart';
import 'package:live_chat/views/chat_view.dart';
import 'package:live_chat/views/user_view.dart';
import 'package:provider/provider.dart';

class AttachShowPage extends StatefulWidget {
  final File attach;

  const AttachShowPage({Key key, this.attach}) : super(key: key);

  @override
  _AttachShowPageState createState() => _AttachShowPageState();
}

class _AttachShowPageState extends State<AttachShowPage> {
  TextEditingController controller;
  FocusNode _focusNode;

  UserView _userView;
  ChatView _chatView;
  List<String> attachFiles = [];

  @override
  void initState() {
    super.initState();
    attachFiles.add(widget.attach.path);
    controller = TextEditingController();
    _focusNode = FocusNode();

    _focusNode.addListener(() {

    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _userView = Provider.of<UserView>(context);
    _chatView = Provider.of<ChatView>(context);

    return Scaffold(
        appBar: AppBar(
            leadingWidth: 85,
            leading: InkWell(
              onTap: () => Navigator.of(context).pop(false),
              child: ContainerRow(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Platform.isAndroid
                        ? Icons.arrow_back
                        : Icons.arrow_back_ios,
                  ),
                  ImageWidget(
                    imageUrl: _chatView.selectedChat.groupType == 'Private'
                        ? _chatView.interlocutorUser.userProfilePhotoUrl
                        : _chatView.selectedChat.groupImageUrl,
                    imageWidth: 50,
                    imageHeight: 50,
                    backgroundShape: BoxShape.circle,
                  ),
                ],
              ),
            ),
            title: Text(_chatView.selectedChat.groupType == 'Private'
                ? _chatView.interlocutorUser.userName
                : _chatView.selectedChat.groupName)),

        body: Container(
          color: Colors.black,
          child: Stack(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        image: FileImage(widget.attach),
                        fit: BoxFit.contain,
                      )
                  )
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ContainerColumn(
                  mainAxisSize: MainAxisSize.min,
                  padding: EdgeInsets.all(10),

                  constraints: BoxConstraints(
                    minHeight: 100,
                    maxHeight: 150
                  ),

                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Theme.of(context).primaryColor,
                  ),
                  children: [
                    ContainerRow(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        IconButton(
                            splashRadius: 25,
                            icon: Icon(Icons.emoji_emotions),
                            onPressed: () {
                              FocusScope.of(context).requestFocus(_focusNode);
                            }
                        ),

                        Expanded(
                          child: Container(
                            child: TextField(
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              controller: controller,
                              focusNode: _focusNode,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: 'Başlık ekleyin...',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 5)
                                // isDense: true,
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                    ContainerRow(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }


  Widget defaultButton() {
    return GestureDetector(
      onTap: () {

      },
      child: Container(
        constraints: BoxConstraints(
          minHeight: 50,
          minWidth: 50,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor,
        ),
        child: Container(
            width: 32,
            height: 32,
            child: Icon(Icons.send, color: Colors.black)),
      ),
    );
  }
}
