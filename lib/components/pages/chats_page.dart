import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_chat/components/common/appbar_widget.dart';
import 'package:live_chat/components/common/user_dialog_widget.dart';
import 'package:live_chat/components/pages/profile_photo_show_page.dart';
import 'package:live_chat/components/pages/user_preview_page.dart';
import 'package:live_chat/services/operation_service.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/container_row.dart';
import 'package:live_chat/components/common/image_widget.dart';
import 'package:live_chat/components/common/title_area.dart';
import 'package:live_chat/components/pages/chat_page.dart';
import 'package:live_chat/models/group_model.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/views/chat_view.dart';
import 'package:live_chat/views/user_view.dart';
import 'package:provider/provider.dart';

class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  UserView _userView;
  ChatView _chatView;

  GlobalKey<AppbarWidgetState> _appbarWidgetState = GlobalKey();

  List<GroupModel> chats;
  List<String> selectedGroupIdList = List<String>();

  @override
  Widget build(BuildContext context) {
    _userView = Provider.of<UserView>(context);
    _chatView = Provider.of<ChatView>(context);

    return Scaffold(
        appBar: AppbarWidget(
          backgroundColor: Theme.of(context).primaryColor,
          operationColor: Theme.of(context).primaryColor.withAlpha(180),
          key: _appbarWidgetState,
          titleText: 'Live Chat',
          operationActions: createOperationActions(),
          onOperationCancel: () {
            setState(() {
              selectedGroupIdList.clear();
            });
          },
        ),
        body: WillPopScope(
          onWillPop: () async {
            if (_appbarWidgetState.currentState.operation) {
              _appbarWidgetState.currentState.operationCancel();
              setState(() {
                selectedGroupIdList.clear();
              });
            }

            return true;
          },
          child: SafeArea(
              child: ContainerColumn(padding: EdgeInsets.all(10), children: [
                TitleArea(titleText: 'Konuşmalarım', icon: Icons.chat, iconColor: Theme.of(context).primaryColor),
                Expanded(
                  child: StreamBuilder<List<GroupModel>>(
                    stream: _chatView.getAllGroups(_userView.user.userId),
                    builder: (context, streamData) {
                      if (streamData.hasData) {
                        chats = streamData.data;

                        if (chats.length > 0)
                          return ListView.builder(
                              itemCount: _chatView.groups.length,
                              itemBuilder: (context, index) => createItem(index)
                              );
                        else
                          return SizedBox.expand(
                            child: ContainerColumn(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.chat, size: 100),
                                Text(
                                  'Kaydedilmiş konuşma yok.',
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          );
                      } else
                        return Container();
                    },
                  ),
                ),
          ])),
        ));
  }

  List<Widget> showMessageText(GroupModel currentChat) {
    switch (currentChat.recentMessage.messageType) {
      case ('Text'):
        return [
          Text('${currentChat.recentMessage.ownerUsername}: '),

          Flexible(
            child: Text(
              currentChat.recentMessage.message,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ];
        break;

      case ('Image'):
        return [
          Text('${currentChat.recentMessage.ownerUsername}: '),
          Icon(Icons.image, size: 18),
          Text('Görüntü')
        ];
        break;

      case ('Voice'):
        return [
          Text('${currentChat.recentMessage.ownerUsername}: '),
          Icon(Icons.mic, size: 18),
          Text('Ses kaydı')
        ];
        break;

      case ('System'):
        return [
          Text('${currentChat.recentMessage.ownerUsername}: '),

          Icon(Icons.info_outline_rounded, size: 18),
          Flexible(
            child: Text(
              currentChat.recentMessage.message,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ];
        break;

      default:
        return [];
        break;
    }
  }

  Widget createItem(int index) {
    GroupModel currentChat = chats[index];

    String controlAction;
    UserModel controlActionUser;

    currentChat.actions.forEach((key, value) {
      if(value['action'] != 0 && key != _userView.user.userId) {
        controlAction = value['action'] == 1 ? 'Yazıyor...' : 'Ses kaydediyor...';
        controlActionUser = _chatView.selectChatUser(key);
      }
    });

    UserModel interlocutorUser;
    if (currentChat.groupType == 'Private') {
      String userId = currentChat.members.where((memberUserId) => memberUserId != _userView.user.userId).first;
      interlocutorUser = _chatView.selectChatUser(userId);
    }

    String currentDates = currentChat.recentMessage.date != null
        ? showDateComposedStringColumn(currentChat.recentMessage.date)
        : null;

    int unreadMessageCount = currentChat.totalMessage - currentChat.actions[_userView.user.userId]['seenMessage'];
    bool selected = selectedGroupIdList.contains(currentChat.groupId);

    return Container(
      margin: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        color: selected ? Colors.grey.withOpacity(0.3) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {

          if(!_appbarWidgetState.currentState.operation) {
            itemInteractionOperation(currentChat, interlocutorUser);
            _chatView.listeningChat = true;
            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => ChatPage()));
          } else {
            selectedListOperation(selected, currentChat);
          }
        },
        onLongPress: () {
          selectedListOperation(selected, currentChat);
        },
        child: ListTile(
            leading: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                if(!_appbarWidgetState.currentState.operation) {

                  itemInteractionOperation(currentChat, interlocutorUser);

                  UserDialogWidget(
                    name: currentChat.groupType == 'Private' ? interlocutorUser.userName : currentChat.groupName,
                    photoUrl: currentChat.groupType == 'Private' ? interlocutorUser.userProfilePhotoUrl : currentChat.groupImageUrl,

                    onPhotoClick: () {
                      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                          builder: (context) => ProfilePhotoShowPage(
                            name: currentChat.groupType == 'Private' ? interlocutorUser.userName : currentChat.groupName,
                            photoUrl: currentChat.groupType == 'Private' ? interlocutorUser.userProfilePhotoUrl : currentChat.groupImageUrl,
                          ))
                      );
                    },

                    onChatClick: () {
                      _chatView.listeningChat = true;
                      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => ChatPage()));
                    },

                    onDetailClick: () async {
                      Color pageColor = await getDynamicColor(_chatView.groupType == 'Private'
                          ? _chatView.interlocutorUser.userProfilePhotoUrl
                          : _chatView.selectedChat.groupImageUrl
                      );

                      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => UserPreviewPage(color: pageColor)));
                    },
                  ).show(context);

                } else {
                  selectedListOperation(selected, currentChat);
                }
              },
              child: ImageWidget(
                image: NetworkImage(currentChat.groupType == 'Private' ? interlocutorUser.userProfilePhotoUrl : currentChat.groupImageUrl),
                imageWidth: 75,
                imageHeight: 75,
                backgroundShape: BoxShape.circle,
                backgroundColor: Colors.grey.withOpacity(0.3),
              ),
            ),
            trailing: ContainerColumn(
              mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,
              children: [
                currentDates != null
                    ? Text(
                      currentDates,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10),
                    )
                    : Text(' '),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(10),
                      color: unreadMessageCount > 0
                          ? Theme.of(context).primaryColor
                          : Colors.transparent),
                  child: Text(
                      unreadMessageCount > 0
                          ? unreadMessageCount.toString()
                          : ' ',

                      style: TextStyle(fontWeight: FontWeight.bold)),
                )
              ],
            ),
            title: Text(
                currentChat.groupType == 'Private'
                    ? interlocutorUser.userName
                    : currentChat.groupName),
            subtitle: ContainerRow(
              children:

              controlAction != null
                  ? [Text(controlActionUser.userName + ' ' + controlAction)]
                  : currentChat.recentMessage != null
                    ? showMessageText(currentChat)
                    : [Text('Yükleniyor...')],
            )
        ),
      ),
    );

  }

  List<Widget> createOperationActions() {
    return [
      selectedGroupIdList.length > 0
          ? Container(
              alignment: Alignment.center,
              width: 50,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black.withOpacity(0.1),
                  ),
                  padding: EdgeInsets.all(5),
                  child: Text(selectedGroupIdList.length.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20))))
          : Container(),

      selectedGroupIdList.length == 1
          ? FlatButton(
              minWidth: 50,
              child: Icon(Icons.remove_red_eye),
              onPressed: () {
                GroupModel currentGroup = _chatView.selectChat(selectedGroupIdList[0]);
                UserModel interlocutorUser;

                if(currentGroup.groupType == 'Private') {
                  String interlocutorUserId = currentGroup.members.firstWhere((memberUserId) => memberUserId != _userView.user.userId, orElse: () => null);
                  interlocutorUser = _chatView.selectChatUser(interlocutorUserId);
                }

                itemInteractionOperation(currentGroup, interlocutorUser);
                _appbarWidgetState.currentState.operationCancel();
                selectedGroupIdList.clear();

                _chatView.listeningChat = true;
                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => ChatPage()));
              })
          : Container(),

      FlatButton(
          minWidth: 50,
          child: Icon(Icons.delete),
          onPressed: () {
            print('Delete işlemleri.');
          })
    ];
  }

  void selectedListOperation(bool selected, GroupModel currentChat) {
    if (selected) {
      setState(() {
        selectedGroupIdList.removeWhere((groupId) => groupId == currentChat.groupId);
      });

      if (selectedGroupIdList.length == 0)
        _appbarWidgetState.currentState.operationCancel();
    } else {
      setState(() {
        selectedGroupIdList.add(currentChat.groupId);
      });

      _appbarWidgetState.currentState.operationOpen();
    }
  }

  void itemInteractionOperation(GroupModel currentChat, UserModel interlocutorUser) {
    _chatView.selectChat(currentChat.groupId);
    _chatView.groupType = currentChat.groupType;

    if(_chatView.groupType == 'Private')
      _chatView.interlocutorUser = interlocutorUser;
    else
      _chatView.selectGroupUser(currentChat.groupId);
  }
}
