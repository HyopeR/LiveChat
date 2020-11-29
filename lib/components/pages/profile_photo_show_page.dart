import 'package:flutter/material.dart';
import 'package:live_chat/components/common/appbar_widget.dart';
import 'package:live_chat/components/common/zoomable_widget.dart';
import 'package:live_chat/views/chat_view.dart';
import 'package:provider/provider.dart';

class ProfilePhotoShowPage extends StatefulWidget {
  @override
  _ProfilePhotoShowPageState createState() => _ProfilePhotoShowPageState();
}

class _ProfilePhotoShowPageState extends State<ProfilePhotoShowPage> {
  ChatView _chatView;

  @override
  Widget build(BuildContext context) {
    _chatView = Provider.of<ChatView>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppbarWidget(
        backgroundColor: Colors.transparent,
        brightness: Brightness.dark,
        textColor: Colors.white,
        onLeftSideClick: () {
          Navigator.of(context).pop();
        },
        titleText: _chatView.groupType == 'Private' ? _chatView.interlocutorUser.userName : _chatView.selectedChat.groupName,
      ),

      body: Container(
        child: ZoomableWidget(
          panEnabled: true,
          minScale: 1,
          maxScale: 4,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: NetworkImage(_chatView.groupType == 'Private' ? _chatView.interlocutorUser.userProfilePhotoUrl : _chatView.selectedChat.groupImageUrl),
                  // image: NetworkImage(attachFiles[0]),
                  fit: BoxFit.contain,
                )
            ),
          ),
        ),
      ),
    );
  }
}
