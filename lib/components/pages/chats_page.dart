import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/image_widget.dart';
import 'package:live_chat/components/common/title_area.dart';
import 'package:live_chat/components/pages/chat_page.dart';
import 'package:live_chat/models/chat_model.dart';
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
                    child: StreamBuilder<List<ChatModel>>(
                      stream: _chatView.getAllChats(_userView.user.userId),
                      builder: (context, streamData) {

                        List<ChatModel> chats = streamData.data;

                        if (streamData.hasData) {
                          if (chats.isNotEmpty)
                            return ListView.builder(
                                itemCount: chats.length,
                                itemBuilder: (context, index) {

                                  ChatModel currentChat = chats[index];
                                  UserModel currentInterlocutor = _chatView.selectChatUser(currentChat.interlocutor);
                                  Map<String, String> dates = showDate(currentChat.createdAt);

                                  return GestureDetector(
                                    onTap: () {

                                      Navigator.of(context, rootNavigator: true)
                                          .push(MaterialPageRoute(builder: (context) => ChatPage(
                                          currentUser: _userView.user,
                                          chatUser: currentInterlocutor,
                                      )));

                                    },

                                    child: ListTile(
                                      leading: ImageWidget(
                                            imageUrl: currentInterlocutor.userProfilePhotoUrl,
                                            imageWidth: 75,
                                            imageHeight: 75,
                                            backgroundShape: BoxShape.circle,
                                            backgroundColor: Colors.grey.withOpacity(0.3),
                                          ),

                                        trailing: currentChat.createdAt != null
                                            ? Text(dates['date'] + '\n' + dates['clock'], textAlign: TextAlign.right,)
                                            : Container(),

                                        title: Text(currentInterlocutor.userName),
                                        subtitle: Text(currentChat.lastMessage.length < 25
                                            ? currentChat.lastMessage
                                            : currentChat.lastMessage.substring(0, 21) + '...'
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
    var formatterDate = DateFormat.yMd();
    var formatterClock = DateFormat.Hm();

    Map<String, String> dates = {
      'date': formatterDate.format(date.toDate()),
      'clock': formatterClock.format(date.toDate()),
    };

    return dates;
  }
}
