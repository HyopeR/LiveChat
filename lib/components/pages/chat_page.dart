import 'dart:io';

import 'package:flutter/material.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/container_row.dart';
import 'package:live_chat/components/common/image_widget.dart';
import 'package:live_chat/components/common/message_bubble.dart';
import 'package:live_chat/components/common/message_creator_widget.dart';
import 'package:live_chat/models/message_model.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/views/chat_view.dart';
import 'package:permission_handler/permission_handler.dart';
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

  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool permissionStatus = false;

  @override
  void initState() {
    super.initState();
    getPermissionStatus();
  }

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
                  child: StreamBuilder<List<MessageModel>>(
                  stream: _chatView.getMessages(
                      widget.currentUser.userId, widget.chatUser.userId),
                  builder: (context, streamData) {
                    List<MessageModel> messages = streamData.data;

                  if (streamData.hasData) {

                    if (messages.isNotEmpty)
                      return Align(
                        alignment: Alignment.topCenter,
                        child: ListView.builder(
                            reverse: true,
                            shrinkWrap: true,
                            controller: _scrollController,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              // print(messages[index].toString());

                              return createMessageBubble(messages[index]);
                            }),
                      );
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
                permissionsAllowed: permissionStatus,
                onPressed: () => saveMessage('Text'),
                onLongPressStart: () async {
                  if (permissionStatus)
                    _chatView.recordStart();
                  else
                    requestPermission();
                },
                onLongPressEnd: () async {
                  if (permissionStatus) {
                    await _chatView.recordStop();
                    saveMessage('Voice');
                  }
                },
              )
            ],
          ),
        ));
  }

  void saveMessage(String messageType) async {
    if (_messageCreatorState.currentState.controller.text.trim().length > 0 ||
        !_messageCreatorState.currentState.voiceRecordCancelled) {
      MessageModel savingMessage = MessageModel(
        senderId: widget.currentUser.userId,
        receiverId: widget.chatUser.userId,
        fromMe: true,
        message: '',
        messageType: messageType,
      );

      switch (messageType) {
        case ('Text'):
          savingMessage.message = _messageCreatorState.currentState.controller.text;

          bool result = await _chatView.saveMessage(savingMessage);
          if (result) {
            _messageCreatorState.currentState.controller.clear();
            _scrollController.animateTo(0,
                duration: Duration(microseconds: 50), curve: Curves.easeOut);
          }
          break;

        case ('Voice'):
          String voiceUrl = await _chatView.uploadVoiceNote(
              widget.currentUser.userId, 'Voice_Notes', _chatView.voiceFile);

          if (voiceUrl != null) {
            savingMessage.message = voiceUrl;
            savingMessage.duration = _messageCreatorState.currentState.oldTime;

            print(savingMessage.toString());

            bool result = await _chatView.saveMessage(savingMessage);
            if (result) {
              _chatView.clearStorage();
              _messageCreatorState.currentState.controller.clear();
              _scrollController.animateTo(0,
                  duration: Duration(microseconds: 50), curve: Curves.easeOut);
            }
          }
          break;

        default:
          break;
      }
    }
  }

  Widget createMessageBubble(MessageModel message) {
    bool _fromMe = message.fromMe;

    if (_fromMe)
      return MessageBubble(
        message: message,
        color: Theme.of(context).primaryColor.withOpacity(0.8),
        fromMe: message.fromMe,
      );
    else
      return MessageBubble(
        message: message,
        color: Colors.grey.shade300.withOpacity(0.8),
        fromMe: message.fromMe,
      );
  }

  getPermissionStatus() async {
    PermissionStatus storagePermission = await Permission.storage.status;
    PermissionStatus microphonePermission = await Permission.microphone.status;
    bool permissionResult =
        (storagePermission.isGranted && microphonePermission.isGranted);
    if (permissionResult) _messageCreatorState.currentState.permissionAllow();

    setState(() {
      permissionStatus = permissionResult;
    });
  }

  requestPermission() async {
    await [Permission.microphone, Permission.storage].request();
  }
}
