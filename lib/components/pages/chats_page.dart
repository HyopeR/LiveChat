import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  DateTime currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    _userView = Provider.of<UserView>(context);
    _chatView = Provider.of<ChatView>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Chats'),
          elevation: 0,
        ),
        body: SafeArea(
            child: ContainerColumn(
                padding: EdgeInsets.all(10),
                children: [

                  TitleArea(titleText: 'Konuşmalarım', icon: Icons.chat),
                  Expanded(
                    child: StreamBuilder<List<GroupModel>>(
                      stream: _chatView.getAllGroups(_userView.user.userId),
                      builder: (context, streamData) {

                        if (streamData.hasData) {
                          List<GroupModel> chats = streamData.data;

                          if (chats.isNotEmpty)
                            return ListView.builder(
                                itemCount: _chatView.groups.length,
                                itemBuilder: (context, index) {

                                  GroupModel currentChat = chats[index];

                                  UserModel interlocutorUser;
                                  if(currentChat.groupType == 'Private') {
                                    String userId = currentChat.members.where((memberUserId) => memberUserId != _userView.user.userId).first;
                                    interlocutorUser = _chatView.selectChatUser(userId);
                                  }

                                  String currentDates = currentChat.recentMessage.date != null
                                      ? showDateComposedString(currentChat.recentMessage.date, currentDate)
                                      : null;

                                  int unreadMessageCount = currentChat.totalMessage - currentChat.seenMessage[_userView.user.userId];

                                  return GestureDetector(
                                    onTap: () {

                                      _chatView.selectChat(currentChat.groupId);
                                      _chatView.interlocutorUser = interlocutorUser;
                                      _chatView.groupType = currentChat.groupType == 'Private' ? 'Private' : 'Plural';
                                      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => ChatPage()));

                                    },

                                    child: ListTile(
                                      leading: ImageWidget(
                                            imageUrl: currentChat.groupType == 'Private' ? interlocutorUser.userProfilePhotoUrl : currentChat.groupImageUrl,
                                            imageWidth: 75,
                                            imageHeight: 75,
                                            backgroundShape: BoxShape.circle,
                                            backgroundColor: Colors.grey.withOpacity(0.3),
                                          ),

                                        trailing: ContainerColumn(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                          children: [
                                            currentDates != null
                                                ? Text(currentDates, textAlign: TextAlign.right,)
                                                : Text(' '),

                                            Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: unreadMessageCount > 0 ? Theme.of(context).primaryColor : Colors.transparent
                                              ),
                                              child: Text(
                                                  unreadMessageCount > 0 ? unreadMessageCount.toString() : ' ',
                                                  style: TextStyle(fontWeight: FontWeight.bold)),
                                            )

                                          ],
                                        ),

                                        title: Text(currentChat.groupType == 'Private' ? interlocutorUser.userName : currentChat.groupName),
                                        subtitle:

                                        ContainerRow(
                                          children: currentChat.recentMessage != null ? showMessageText(currentChat) : Text('Yükleniyor...'),
                                        )
                                    ),
                                  );
                                });
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

                ]
            )
        )
    );
  }

  List<Widget> showMessageText(GroupModel currentChat) {

    switch(currentChat.recentMessage.messageType) {

      case('Text'):
        return [
          currentChat.groupType == 'Private' ? Container() : Text('${currentChat.recentMessage.ownerUsername}: '),
          Text(currentChat.recentMessage.message.length > 32

              ? currentChat.recentMessage.message.substring(0, 28) + '...'
              : currentChat.recentMessage.message)
        ];
        break;

      case('Image'):
        return [
          currentChat.groupType == 'Private' ? Container() : Text('${currentChat.recentMessage.ownerUsername}: '),
          Icon(Icons.image, size: 20),
          Text('Görüntü')
        ];
        break;

      case('Voice'):
        return [
          currentChat.groupType == 'Private' ? Container() : Text('${currentChat.recentMessage.ownerUsername}: '),
          Icon(Icons.mic, size: 20),
          Text('Ses kaydı')
        ];
        break;

      default:
        return [];
        break;

    }

  }
}
