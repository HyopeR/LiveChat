import 'dart:io';

import 'package:flutter/material.dart';
import 'package:live_chat/components/common/container_row.dart';
import 'package:live_chat/components/common/image_widget.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/views/chat_view.dart';
import 'package:live_chat/views/user_view.dart';
import 'package:provider/provider.dart';

class AttachShowPage extends StatefulWidget {
  File attach;
  UserModel interlocutorUser;

  AttachShowPage.private({Key key, this.attach, this.interlocutorUser}) : super(key: key);
  AttachShowPage.plural({Key key, this.attach}) : super(key: key);

  @override
  _AttachShowPageState createState() => _AttachShowPageState();
}

class _AttachShowPageState extends State<AttachShowPage> {
  UserView _userView;
  ChatView _chatView;
  List<String> attachFiles = [];

  @override
  void initState() {
    super.initState();
    attachFiles.add(widget.attach.path);
  }

  @override
  Widget build(BuildContext context) {
    _userView = Provider.of<UserView>(context);
    _chatView = Provider.of<ChatView>(context);

    return Scaffold(
      appBar: AppBar(
          leadingWidth: 85,
          leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
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
                  imageUrl: _chatView.selectedChat.groupType == 'Private' ? widget.interlocutorUser.userProfilePhotoUrl : _chatView.selectedChat.groupImageUrl,
                  imageWidth: 50,
                  imageHeight: 50,
                  backgroundShape: BoxShape.circle,
                ),
              ],
            ),
          ),
          title: Text(_chatView.selectedChat.groupType == 'Private' ? widget.interlocutorUser.userName : _chatView.selectedChat.groupName)
      ),

      body: Container(
        child: Center(
          child: Image.file(widget.attach),
        )
      ),
    );
  }
}
