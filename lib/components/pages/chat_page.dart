import 'dart:io';

import 'package:flutter/material.dart';
import 'package:live_chat/components/common/appbar_widget.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/message_bubble.dart';
import 'package:live_chat/components/common/message_creator_widget.dart';
import 'package:live_chat/components/common/message_marked.dart';
import 'package:live_chat/components/pages/attach_show_page.dart';
import 'package:live_chat/components/pages/camera_page.dart';
import 'package:live_chat/models/message_model.dart';
import 'package:live_chat/views/chat_view.dart';
import 'package:live_chat/views/user_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final String groupType;

  ChatPage.private({Key key, this.groupType = 'Private'}) : super(key: key);

  ChatPage.plural({Key key, this.groupType = 'Plural'}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatView _chatView;
  UserView _userView;

  GlobalKey<MessageCreatorWidgetState> _messageCreatorState = GlobalKey();
  ScrollController _scrollController = ScrollController();

  bool permissionStatus = false;
  MessageModel markedMessage;
  List<File> attachFileList;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getPermissionStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    _userView = Provider.of<UserView>(context);
    _chatView = Provider.of<ChatView>(context);

    return Scaffold(
        appBar: AppbarWidget(
            onLeftSideClick: () {
              Navigator.of(context).pop();
            },
            titleImageUrl: widget.groupType == 'Private'
                ? _chatView.interlocutorUser.userProfilePhotoUrl
                : _chatView.selectedChat.groupImageUrl,
            titleText: widget.groupType == 'Private'
                ? _chatView.interlocutorUser.userName
                : _chatView.selectedChat.groupName),
        body: SafeArea(
          child: ContainerColumn(
            padding: EdgeInsets.all(10),
            children: [

              _chatView.selectedChatState == SelectedChatState.Loaded
                  ? Expanded(
                  child: StreamBuilder<List<MessageModel>>(
                    stream: _chatView.getMessages(_chatView.selectedChat.groupId),
                    builder: (context, streamData) {

                      if (streamData.hasData) {
                        List<MessageModel> messages = streamData.data;

                        if (messages.isNotEmpty) {
                          return Align(
                            alignment: Alignment.topCenter,
                            child: ListView.builder(
                                reverse: true,
                                shrinkWrap: true,
                                controller: _scrollController,
                                itemCount: messages.length,
                                itemBuilder: (context, index) {

                                  MessageModel currentMessage = messages[index];
                                  bool fromMe = currentMessage.sendBy == _userView.user.userId;
                                  currentMessage.fromMe = fromMe;

                                  if(widget.groupType == 'Private') {
                                    currentMessage.ownerImageUrl = fromMe ? _userView.user.userProfilePhotoUrl : _chatView.interlocutorUser.userProfilePhotoUrl;
                                    currentMessage.ownerUsername = fromMe ? _userView.user.userName : _chatView.interlocutorUser.userName;

                                    if(currentMessage.markedMessage != null) {
                                      bool markedFromMe = currentMessage.markedMessage.sendBy == _userView.user.userId;
                                      currentMessage.markedMessage.ownerImageUrl = markedFromMe ? _userView.user.userProfilePhotoUrl : _chatView.interlocutorUser.userProfilePhotoUrl;
                                      currentMessage.markedMessage.ownerUsername = markedFromMe ? _userView.user.userName : _chatView.interlocutorUser.userName;
                                    }
                                  }

                                  return Dismissible(
                                      key: Key(currentMessage.messageId),
                                      direction: DismissDirection.startToEnd,
                                      // confirmDismiss: (direction) async => direction == DismissDirection.startToEnd ? false : false,
                                      confirmDismiss: (direction) async {
                                        _messageCreatorState.currentState..setMarkedMessage(
                                            MessageMarked(
                                              message: currentMessage,
                                              mainAxisSize: MainAxisSize.max,
                                              forwardCancel: () {
                                                _messageCreatorState.currentState.setMarkedMessage(null);
                                                markedMessage = null;
                                              },
                                            )
                                        );


                                        markedMessage = currentMessage;
                                        return false;
                                      },

                                      child: MessageBubble(
                                        message: currentMessage,
                                        color: currentMessage.fromMe ? Theme.of(context).primaryColor.withOpacity(0.8) : Colors.grey.shade300.withOpacity(0.8),
                                      )
                                  );
                                }),
                          );
                        } else
                          return Container();
                      } else
                        return Container();
                    },
                  ))

                  : Expanded(child: Container(child: Center(child: Text('Bir konuşma başlat.')))),
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

                useCamera: () {
                  addAttach();
                },

                useAttach: () {

                },
              )
            ],
          ),
        ));
  }

  void saveMessage(String messageType) async {
    if (_messageCreatorState.currentState.controller.text.trim().length > 0 ||
        !_messageCreatorState.currentState.voiceRecordCancelled) {
      if (_chatView.selectedChatState == SelectedChatState.Empty) {
        await _chatView.getGroupIdByUserIdList(
            _userView.user.userId,
            widget.groupType,
            [_userView.user.userId, _chatView.interlocutorUser.userId]);
        sendMessage(messageType);
      } else {
        sendMessage(messageType);
      }
    }
  }

  sendMessage(String messageType) async {
    MessageModel savingMessage = MessageModel(
      sendBy: _userView.user.userId,
      message: '',
      messageType: messageType,
    );

    if (markedMessage != null) savingMessage.markedMessage = markedMessage;

    switch (messageType) {
      case ('Text'):
        savingMessage.message =
            _messageCreatorState.currentState.controller.text;

        bool result = await _chatView.saveMessage(
            savingMessage, _userView.user, _chatView.selectedChat.groupId);
        if (result) {
          markedMessage = null;

          _messageCreatorState.currentState.controller.clear();
          _messageCreatorState.currentState.setMarkedMessage(null);
          _scrollController.animateTo(0,
              duration: Duration(microseconds: 50), curve: Curves.easeOut);
        }
        break;

      case ('Voice'):
        String voiceUrl = await _chatView.uploadVoiceNote(
            _userView.user.userId, 'Voice_Notes', _chatView.voiceFile);

        if (voiceUrl != null) {
          savingMessage.message = voiceUrl;
          savingMessage.duration = _messageCreatorState.currentState.oldTime;

          bool result = await _chatView.saveMessage(
              savingMessage, _userView.user, _chatView.selectedChat.groupId);
          if (result) {
            markedMessage = null;

            _chatView.clearStorage();
            _messageCreatorState.currentState.controller.clear();
            _messageCreatorState.currentState.setMarkedMessage(null);
            _scrollController.animateTo(0,
                duration: Duration(microseconds: 50), curve: Curves.easeOut);
          }
        }
        break;

      default:
        break;
    }
  }

  addAttach() async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AttachShowPage()))
        .then((value) {
          print(value);
        });
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
