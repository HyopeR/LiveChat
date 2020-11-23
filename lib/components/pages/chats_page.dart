import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_chat/components/common/appbar_widget.dart';
import 'package:live_chat/components/common/user_dialog_widget.dart';
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

            return false;
          },
          child: SafeArea(
              child: ContainerColumn(padding: EdgeInsets.all(10), children: [
                TitleArea(titleText: 'Konuşmalarım', icon: Icons.chat),
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
          currentChat.groupType == 'Private'
              ? Container()
              : Text('${currentChat.recentMessage.ownerUsername}: '),
          Text(currentChat.recentMessage.message.length > 32
              ? currentChat.recentMessage.message.substring(0, 28) + '...'
              : currentChat.recentMessage.message)
        ];
        break;

      case ('Image'):
        return [
          currentChat.groupType == 'Private'
              ? Container()
              : Text('${currentChat.recentMessage.ownerUsername}: '),
          Icon(Icons.image, size: 20),
          Text('Görüntü')
        ];
        break;

      case ('Voice'):
        return [
          currentChat.groupType == 'Private'
              ? Container()
              : Text('${currentChat.recentMessage.ownerUsername}: '),
          Icon(Icons.mic, size: 20),
          Text('Ses kaydı')
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
        ? showDateComposedString(currentChat.recentMessage.date)
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
          _chatView.selectChat(currentChat.groupId);
          _chatView.groupType = currentChat.groupType == 'Private' ? 'Private' : 'Plural';

          if(_chatView.groupType == 'Private')
            _chatView.interlocutorUser = interlocutorUser;

          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => ChatPage()));
        },
        onLongPress: () {
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
        },
        child: ListTile(
            leading: InkWell(
              onTap: () {
                UserDialogWidget(
                  userName: 'Username',
                ).show(context).then((value) {

                });
              },
              child: ImageWidget(
                imageUrl: currentChat.groupType == 'Private' ? interlocutorUser.userProfilePhotoUrl : currentChat.groupImageUrl,
                imageWidth: 75,
                imageHeight: 75,
                backgroundShape: BoxShape.circle,
                backgroundColor:
                Colors.grey.withOpacity(0.3),
              ),
            ),
            trailing: ContainerColumn(
              mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,
              children: [
                currentDates != null
                    ? Text(
                  currentDates,
                  textAlign: TextAlign.right,
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
            )),
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
                _chatView.groupType = currentGroup.groupType;

                if(_chatView.groupType == 'Private') {
                  String interlocutorUserId = currentGroup.members.firstWhere((memberUserId) => memberUserId != _userView.user.userId, orElse: () => null);
                  _chatView.interlocutorUser = _chatView.selectChatUser(interlocutorUserId);
                }

                _appbarWidgetState.currentState.operationCancel();
                selectedGroupIdList.clear();
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
}
