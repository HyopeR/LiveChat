import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:path/path.dart' as path;
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:live_chat/components/common/appbar_widget.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/container_row.dart';
import 'package:live_chat/components/common/message_bubble.dart';
import 'package:live_chat/components/common/message_creator_widget.dart';
import 'package:live_chat/components/common/message_marked.dart';
import 'package:live_chat/components/pages/camera_preview_page.dart';
import 'package:live_chat/components/pages/user_preview_page.dart';
import 'package:live_chat/models/group_model.dart';
import 'package:live_chat/models/message_model.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/services/operation_service.dart';
import 'package:live_chat/views/chat_view.dart';
import 'package:live_chat/views/user_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatView _chatView;
  UserView _userView;

  StreamSubscription<UserModel> _subscriptionUser;
  StreamSubscription<GroupModel> _subscriptionGroup;
  UserModel interlocutorUser;

  LocalFileSystem _localFileSystem = LocalFileSystem();
  GlobalKey<AppbarWidgetState> _appbarWidgetState = GlobalKey();
  GlobalKey<MessageCreatorWidgetState> _messageCreatorState = GlobalKey();
  ScrollController _scrollController = ScrollController();

  bool permissionStatus = false;
  MessageModel markedMessage;
  List<Map<String, dynamic>> attachFileList;

  List<MessageModel> selectedMessagesList = List<MessageModel>();
  List<MessageModel> messages;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      getPermissionStatus();

      if(_messageCreatorState.currentState != null)
        _messageCreatorState.currentState.focusNode.addListener(() {
          setState(() {});
        });

      if(_chatView.groupType == 'Private') {
        _subscriptionUser = _chatView.streamOneUser(_chatView.interlocutorUser.userId).listen((user) {

          if(_appbarWidgetState.currentState != null) {
            interlocutorUser = user;
            String subTitleText = user.online
                ? 'Online'
                : 'Son görülme: ' + showDateComposedString(user.lastSeen);
            _appbarWidgetState.currentState.updateSubtitle(subTitleText == null ? ' ' : subTitleText);
          }

        });
      }

      if(_chatView.selectedChat != null) {
        _subscriptionGroup = _chatView.streamOneGroup(_chatView.selectedChat.groupId).listen((group) {
          if(_appbarWidgetState.currentState != null) {

            String controlAction;
            UserModel controlActionUser;

            group.actions.forEach((key, value) {
              if(value['action'] != 0 && key != _userView.user.userId) {
                controlAction = value['action'] == 1 ? 'Yazıyor...' : 'Ses kaydediyor...';
                controlActionUser = _chatView.selectChatUser(key);
              }
            });

            if(controlAction != null)
              _appbarWidgetState.currentState.updateSubtitle(controlActionUser.userName + ' ' + controlAction);
            else if(_chatView.groupType == 'Private') {
              String subTitleText = interlocutorUser.online
                  ? 'Online'
                  : 'Son görülme: ' + showDateComposedString(interlocutorUser.lastSeen);

              _appbarWidgetState.currentState.updateSubtitle(subTitleText == null ? ' ' : subTitleText);
            }

          }
        });
      }

    });
  }

  @override
  void dispose() {
    _subscriptionUser != null ? _subscriptionUser.cancel() : _subscriptionUser = null;
    _subscriptionGroup != null ? _subscriptionGroup.cancel() : _subscriptionGroup = null;
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _userView = Provider.of<UserView>(context);
    _chatView = Provider.of<ChatView>(context);

    return KeyboardVisibilityBuilder(
      builder: (context, isVisible) {
        return OrientationBuilder(
          builder: (context, orientation) {
            bool orientationLandscape = orientation == Orientation.landscape;

            if(orientationLandscape)
              return !isVisible ? defaultPage() : textAreaPage();
            else
              return defaultPage();
          },
        );
      },
    );
  }

  Widget textAreaPage() {
    return Scaffold(
      body: SafeArea(
        child: ContainerRow(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: MessageCreatorWidget(
                  margin: EdgeInsets.all(10),
                  key: _messageCreatorState,
                  hintText: 'Bir mesaj yazın.',
                  textAreaColor: Colors.grey.shade300.withOpacity(0.8),
                  textAreaMaxHeight: MediaQuery.of(context).size.height,
                  textAreaCrossAxisAlignment: CrossAxisAlignment.start,
                  iconAlignment: Alignment.bottomCenter,
                  buttonColor: Theme.of(context).primaryColor,
                  permissionsAllowed: permissionStatus,

                  onWriting: () => updateMessageAction(1),
                  onWritingStop: () => updateMessageAction(0),
                ),
              ),
            ),

            KeyboardDismissOnTap(
              child: Container(
                width: 50,
                height: MediaQuery.of(context).size.height,
                color: Theme.of(context).primaryColor,
                child: Icon(Icons.done),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget defaultPage() {
    String appBarImageUrl = _chatView.groupType == 'Private'
        ? _chatView.interlocutorUser.userProfilePhotoUrl
        : _chatView.selectedChat.groupImageUrl;

    String appBarTitle = _chatView.groupType == 'Private'
        ? _chatView.interlocutorUser.userName
        : _chatView.selectedChat.groupName;

    String appBarSubtitle = _chatView.groupType == 'Private'
        ? _chatView.selectChatUser(_chatView.interlocutorUser.userId).online
        ? 'Online'
        : 'Son görülme: ' + showDateComposedString(_chatView.interlocutorUser.lastSeen)
        : 'Group';

    return WillPopScope(
      onWillPop: () async {
        if (_appbarWidgetState.currentState.operation) {
          _appbarWidgetState.currentState.operationCancel();
          setState(() {
            selectedMessagesList.clear();
          });
        } else {
          if(_messageCreatorState.currentState.controller.text.trim().length > 0) {
            _messageCreatorState.currentState.controller.clear();
            updateMessageAction(0);
          }
          Navigator.of(context).pop();
          _chatView.unSelectChat();
          _chatView.resetMessages();
        }

        return false;
      },

      child: Scaffold(
          appBar: AppbarWidget(
            key: _appbarWidgetState,
            onLeftSideClick: () {
              if(_messageCreatorState.currentState.controller.text.trim().length > 0) {
                _messageCreatorState.currentState.controller.clear();
                updateMessageAction(0);
              }
              Navigator.of(context).pop();
              _chatView.unSelectChat();
              _chatView.resetMessages();
            },
            appBarType: 'Chat',

            titleImageUrl: appBarImageUrl,
            titleText: appBarTitle,
            subTitleText: appBarSubtitle,

            onTitleClick: () async {
              Color userColor = await getDynamicColor(_chatView.interlocutorUser.userProfilePhotoUrl);
              await Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserPreviewPage(color: userColor)));
            },

            operationActions: createOperationActions(),

            onOperationCancel: () {
              setState(() {
                selectedMessagesList.clear();
              });
            },
          ),

          body: SafeArea(
            child: ContainerColumn(
              children: [
                _chatView.selectedChatState == SelectedChatState.Loaded && _chatView.selectedChat != null
                    ? Expanded(
                    child: StreamBuilder<List<MessageModel>>(
                      stream: _chatView.getMessages(_chatView.selectedChat.groupId),
                      builder: (context, streamData) {
                        if (streamData.hasData) {
                          messages = streamData.data;

                          if (messages.isNotEmpty) {
                            return Align(
                              alignment: Alignment.topCenter,
                              child: ListView.builder(
                                  reverse: true,
                                  shrinkWrap: true,
                                  controller: _scrollController,
                                  itemCount: messages.length,
                                  itemBuilder: (context, index) => createItem(index)
                              ),
                            );
                          } else
                            return Container();
                        } else
                          return Container();
                      },
                    ))
                    : Expanded(
                    child: Container(
                        child: Center(child: Text('Bir konuşma başlat.')))),

                MessageCreatorWidget(
                  margin: EdgeInsets.all(10),
                  key: _messageCreatorState,
                  hintText: 'Bir mesaj yazın.',
                  textAreaColor: Colors.grey.shade300.withOpacity(0.8),
                  textAreaMaxHeight: MediaQuery.of(context).orientation == Orientation.portrait ? 150 : 120,
                  buttonColor: Theme.of(context).primaryColor,
                  permissionsAllowed: permissionStatus,

                  onWriting: () => updateMessageAction(1),
                  onWritingStop: () => updateMessageAction(0),

                  onPressed: () => saveMessage('Text'),

                  onLongPressStart: () async {
                    if (permissionStatus) {
                      _chatView.recordStart();
                      updateMessageAction(2);
                    } else {
                      requestPermission();
                    }
                  },

                  onLongPressEnd: () async {
                    if (permissionStatus) {
                      await _chatView.recordStop();

                      if(_messageCreatorState.currentState.voiceRecordCancelled)
                        _chatView.clearStorage();
                      else
                        saveMessage('Voice');

                      updateMessageAction(0);
                    }
                  },

                  useCamera: () async {
                    if (permissionStatus)
                      addAttach();
                    else {
                      bool allowControl = await requestPermission();
                      if (allowControl) addAttach();
                    }
                  },

                  useAttach: () {},
                )
              ],
            ),
          )),
    );
  }

  void updateMessageAction(int actionCode) {
    if(_chatView.selectedChat != null)
      _chatView.updateMessageAction(actionCode, _userView.user.userId, _chatView.selectedChat.groupId);
  }

  void saveMessage(String messageType) async {
    if (_messageCreatorState.currentState.controller.text.trim().length > 0 ||
        !_messageCreatorState.currentState.voiceRecordCancelled) {
      if (_chatView.selectedChatState == SelectedChatState.Empty) {
        await _chatView.getGroupIdByUserIdList(
            _userView.user.userId,
            _chatView.groupType,
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
          _scrollController.animateTo(0, duration: Duration(microseconds: 50), curve: Curves.easeOut);
        }
        break;

      case ('Voice'):
        String voiceUrl = await _chatView.uploadVoiceNote(_chatView.selectedChat.groupId, 'Voice_Notes', _chatView.voiceFile);

        if (voiceUrl != null) {
          savingMessage.message = voiceUrl;
          savingMessage.duration = _messageCreatorState.currentState.oldTime;

          bool result = await _chatView.saveMessage(savingMessage, _userView.user, _chatView.selectedChat.groupId);
          if (result) {
            markedMessage = null;

            _chatView.clearStorage();
            _messageCreatorState.currentState.controller.clear();
            _messageCreatorState.currentState.setMarkedMessage(null);
            _scrollController.animateTo(0, duration: Duration(microseconds: 50), curve: Curves.easeOut);
          }
        }
        break;

      case ('Image'):
        attachFileList.forEach((Map<String, dynamic> map) async {
          Map<String, String> uploadData = await _chatView.uploadImage(_chatView.selectedChat.groupId, 'Images', map['file']);
          String imageUrl = uploadData['url'];
          String imageName = uploadData['name'];

          if (imageUrl != null) {
            savingMessage.attach = imageUrl;
            savingMessage.message = map['text'] != null ? map['text'] : '';

            bool result = await _chatView.saveMessage(savingMessage, _userView.user, _chatView.selectedChat.groupId);
            if (result) {
              markedMessage = null;
              _scrollController.animateTo(0, duration: Duration(microseconds: 50), curve: Curves.easeOut);
            }
          }

          // Telefona gönderilen resmin kaydedilmesi.
          try{
            String dir = (await getApplicationDocumentsDirectory()).path;
            String newPath = path.join(dir, '${_chatView.selectedChat.groupId}_$imageName');
            await File(map['file'].path).copy(newPath);

            await GallerySaver.saveImage(newPath, albumName: 'Live Chat Images').whenComplete(() async {
              await _localFileSystem.file(newPath).delete();
              await _localFileSystem.file(map['file'].path).delete();
            });

          }catch(err) {
            print('GallerySaver.saveImage Error: ' + err.toString());
          }
        });

        _messageCreatorState.currentState.setMarkedMessage(null);
        attachFileList = [];
        break;

      default:
        break;
    }
  }

  addAttach() async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CameraPreviewPage()))
        .then((listData) async {
      if (listData.length > 0) {
        attachFileList = listData;
        saveMessage('Image');
      }
    });
  }

  getPermissionStatus() async {
    if (await Permission.microphone.isGranted &&
        await Permission.storage.isGranted) {
      _messageCreatorState.currentState.permissionAllow();
      setState(() {
        permissionStatus = true;
      });
    }
  }

  Future<bool> requestPermission() async {
    Map<Permission, PermissionStatus> result =
    await [Permission.microphone, Permission.storage].request();
    if (result[Permission.microphone].isGranted &&
        result[Permission.storage].isGranted) {
      _messageCreatorState.currentState.permissionAllow();

      setState(() {
        permissionStatus = true;
      });

      return true;
    } else
      return false;
  }

  Widget createItem(int index) {
    MessageModel currentMessage = messages[index];
    bool fromMe = currentMessage.sendBy == _userView.user.userId;
    currentMessage.fromMe = fromMe;

    if (_chatView.groupType == 'Private') {
      currentMessage.ownerImageUrl = fromMe
          ? _userView.user.userProfilePhotoUrl
          : _chatView.interlocutorUser.userProfilePhotoUrl;

      currentMessage.ownerUsername = fromMe
          ? _userView.user.userName
          : _chatView.interlocutorUser.userName;

      if (currentMessage.markedMessage != null) {
        bool markedFromMe = currentMessage.markedMessage.sendBy == _userView.user.userId;

        currentMessage.markedMessage.ownerImageUrl = markedFromMe
            ? _userView.user.userProfilePhotoUrl
            : _chatView.interlocutorUser.userProfilePhotoUrl;

        currentMessage.markedMessage.ownerUsername = markedFromMe
            ? _userView.user.userName
            : _chatView.interlocutorUser.userName;
      }
    }

    bool selected = selectedMessagesList.map((e) => e.messageId).contains(currentMessage.messageId);

    return Dismissible(
        key: Key(currentMessage.messageId),
        direction: DismissDirection.startToEnd,
        // confirmDismiss: (direction) async => direction == DismissDirection.startToEnd ? false : false,
        confirmDismiss: (direction) async {
          _messageCreatorState.currentState
              .setMarkedMessage(MessageMarked(
            message: currentMessage,
            mainAxisSize: MainAxisSize.max,
            forwardCancel: () {
              _messageCreatorState.currentState.setMarkedMessage(null);
              markedMessage = null;
            },
          ));

          markedMessage = currentMessage;
          return false;
        },
        child: Container(
          decoration: BoxDecoration(
            color: selected ? Colors.black.withOpacity(0.3) : Colors.transparent,
          ),

          child: InkWell(
            onLongPress: () {
              if (selected) {
                setState(() {
                  selectedMessagesList.removeWhere((message) => message.messageId == currentMessage.messageId);
                });

                if (selectedMessagesList.length == 0) _appbarWidgetState.currentState.operationCancel();
              } else {
                setState(() {
                  selectedMessagesList.add(currentMessage);
                });

                _appbarWidgetState.currentState
                    .operationOpen();
              }
            },

            child: MessageBubble(
              message: currentMessage,
              color: currentMessage.fromMe
                  ? Theme.of(context).primaryColor.withOpacity(0.8)
                  : Colors.grey.shade300.withOpacity(0.8),
            ),
          ),
        )
    );
  }


  List<Widget> createOperationActions() {
    return [
      selectedMessagesList.length > 0
          ? Container(
          alignment: Alignment.center,
          width: 50,
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black.withOpacity(0.1),
              ),
              padding: EdgeInsets.all(5),
              child: Text(selectedMessagesList.length.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20))))
          : Container(),

      selectedMessagesList.length == 1

          ? FlatButton(
          minWidth: 50,
          child: Icon(Icons.reply),
          onPressed: () {
            setState(() {
              markedMessage = selectedMessagesList[0];
              _messageCreatorState.currentState.setMarkedMessage(MessageMarked(
                message: markedMessage,
                mainAxisSize: MainAxisSize.max,
                forwardCancel: () {
                  _messageCreatorState.currentState.setMarkedMessage(null);
                  markedMessage = null;
                },
              ));
            });

            _appbarWidgetState.currentState.operationCancel();
            selectedMessagesList.clear();
          })

          : Container(),

      FlatButton(
          minWidth: 50,
          child: Transform(
              child: Icon(Icons.reply),
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi)
          ),
          onPressed: () {
            print('Mesajları iletme işlemleri.');
          })
    ];
  }

}
