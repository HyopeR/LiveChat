import 'package:flutter/material.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/models/user_model.dart';

class ChatPage extends StatefulWidget {

  final UserModel currentUser;
  final UserModel chatUser;

  const ChatPage({
    Key key,
    this.currentUser,
    this.chatUser
  }) : super(key: key);


  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: ContainerColumn(
            children: [
              Text('Current User: ' + widget.currentUser.userName),
              Text('Chat User: ' + widget.chatUser.userName)
            ],
          ),
        ),
      )
    );
  }
}
