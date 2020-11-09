import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:live_chat/components/common/container_column.dart';
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

                        List<GroupModel> chats = streamData.data;

                        if (streamData.hasData) {
                          if (chats.isNotEmpty)
                            return ListView.builder(
                                itemCount: chats.length,
                                itemBuilder: (context, index) {

                                  GroupModel currentChat = chats[index];
                                  print(currentChat.toString());

                                  UserModel interlocutorUser;
                                  if(currentChat.groupType == 'Private') {
                                    String userId = currentChat.members.where((memberUserId) => memberUserId != _userView.user.userId).first;
                                    interlocutorUser = _chatView.selectChatUser(userId);
                                  }


                                  Map<String, String> dates = currentChat.createdAt != null
                                      ? showDate(currentChat.updatedAt)
                                      : null;

                                  return GestureDetector(
                                    onTap: () {

                                      _chatView.selectChat(currentChat.groupId);
                                      currentChat.groupType == 'Private'
                                          ? Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => ChatPage.private(interlocutorUser: interlocutorUser)))
                                          : Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => ChatPage.plural()));

                                    },

                                    child: ListTile(
                                      leading: ImageWidget(
                                            imageUrl: currentChat.groupType == 'Private' ? interlocutorUser.userProfilePhotoUrl : currentChat.groupImageUrl,
                                            imageWidth: 75,
                                            imageHeight: 75,
                                            backgroundShape: BoxShape.circle,
                                            backgroundColor: Colors.grey.withOpacity(0.3),
                                          ),

                                        trailing: dates != null
                                                    ? Text(dates['date'] + '\n' + dates['clock'], textAlign: TextAlign.right,)
                                                    : Text(' '),

                                        title: Text(currentChat.groupType == 'Private' ? interlocutorUser.userName : currentChat.groupName),
                                        subtitle: Text(currentChat.recentMessage.length < 25
                                            ? currentChat.recentMessage
                                            : currentChat.recentMessage.substring(0, 21) + '...'
                                        ),
                                    ),
                                  );
                                });
                          else
                            return SizedBox.expand(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
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

  Map<String, String> showDate(Timestamp date) {
    DateTime serverDate = date.toDate();
    int differenceDay = currentDate.difference(serverDate).inDays;

    var formatterDate = DateFormat.yMd();
    var formatterClock = DateFormat.Hm();

    Map<String, String> dates = {
      'date': '',
      'clock': formatterClock.format(serverDate),
    };

    switch(differenceDay) {
      case(0):
        dates.update('date', (value) => 'Bugün');
        return dates;

      case(1):
        dates.update('date', (value) => 'Dün');
        return dates;

      default:
        dates.update('date', (value) => formatterDate.format(serverDate));
        return dates;

    }
  }
}
