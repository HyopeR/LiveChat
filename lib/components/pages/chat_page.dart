import 'dart:io';

import 'package:flutter/material.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/container_row.dart';
import 'package:live_chat/components/common/image_widget.dart';
import 'package:live_chat/components/common/message_creator_widget.dart';
import 'package:live_chat/models/chat_model.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/views/chat_view.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final UserModel currentUser;
  final UserModel chatUser;

  const ChatPage({Key key, this.currentUser, this.chatUser}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatView _chatView;
  GlobalKey<MessageCreatorWidgetState> _messageCreatorState = GlobalKey();
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
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
                    imageUrl: widget.chatUser.userProfilePhotoUrl,
                    imageWidth: 50,
                    imageHeight: 50,
                    backgroundShape: BoxShape.circle,
                  ),
                ],
              ),
            ),
            title: Text(widget.chatUser.userName)),
        body: SafeArea(
          child: ContainerColumn(
            padding: EdgeInsets.all(10),
            children: [
              Expanded(
                  child: StreamBuilder<List<ChatModel>>(
                stream: _chatView.getMessages(
                    widget.currentUser.userId, widget.chatUser.userId),
                builder: (context, streamData) {
                  List<ChatModel> messages = streamData.data;

                  if (streamData.hasData) {
                    if (messages.isNotEmpty)
                      return ListView.builder(
                          reverse: true,
                          controller: _scrollController,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return createTalkingBalloon(messages[index]);
                          });
                    else
                      return Center(child: Text('Bir konuşma başlat'));
                  } else
                    return Container();
                },
              )),
              MessageCreatorWidget(
                margin: EdgeInsets.only(top: 10),

                key: _messageCreatorState,
                hintText: 'Bir mesaj yazın.',
                textAreaColor: Colors.grey.shade300.withOpacity(0.8),
                buttonColor: Theme.of(context).primaryColor,
                onPressed: () => saveMessage(),
              )
            ],
          ),
        ));
  }

  void saveMessage() async {
    if (_messageCreatorState.currentState.controller.text.trim().length > 0) {
      ChatModel savingMessage = ChatModel(
        senderId: widget.currentUser.userId,
        receiverId: widget.chatUser.userId,
        fromMe: true,
        message: _messageCreatorState.currentState.controller.text,
      );

      bool result = await _chatView.saveMessage(savingMessage);
      if (result) {
        _messageCreatorState.currentState.controller.clear();
        _scrollController.animateTo(
            0,
            duration: Duration(microseconds: 50),
            curve: Curves.easeOut
        );
      }
    }
  }

  Widget createTalkingBalloon(ChatModel message) {
    Color _outgoingMessageColor =
        Theme.of(context).primaryColor.withOpacity(0.8);
    Color _incomingMessageColor = Colors.grey.shade300.withOpacity(0.8);
    bool _fromMe = message.fromMe;

    if (_fromMe)
      return ContainerColumn(
        margin: EdgeInsets.only(top: 5),
        alignment: Alignment.centerRight,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {},
            child: Material(
              elevation: 0,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(message.message),
              ),
              color: _outgoingMessageColor,
            ),
          ),
        ],
      );
    else
      return ContainerColumn(
        margin: EdgeInsets.only(top: 5),
        alignment: Alignment.centerLeft,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {},
            child: Material(
              elevation: 0,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(message.message),
              ),
              color: _incomingMessageColor,
            ),
          ),
        ],
      );
  }
}
