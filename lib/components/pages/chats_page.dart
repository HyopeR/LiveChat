import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
                    child: FutureBuilder<List<ChatModel>>(
                      future: _chatView.getAllChats(_userView.user.userId),
                      builder: (context, streamData) {

                        List<ChatModel> chats = streamData.data;

                        if (streamData.hasData) {
                          if (chats.isNotEmpty)
                            return ListView.builder(
                                itemCount: chats.length,
                                itemBuilder: (context, index) {
                                  ChatModel currentChat = chats[index];

                                  return GestureDetector(
                                    onTap: () {

                                      Navigator.of(context, rootNavigator: true)
                                          .push(MaterialPageRoute(builder: (context) => ChatPage(
                                          currentUser: _userView.user,
                                          chatUser: _chatView.selectChatUser(currentChat.interlocutor),
                                      )));

                                    },

                                    child: ListTile(
                                      leading: ImageWidget(
                                        imageUrl: currentChat.interlocutorProfilePhotoUrl,
                                        imageWidth: 75,
                                        imageHeight: 75,
                                        backgroundShape: BoxShape.circle,
                                        backgroundColor: Colors.grey.withOpacity(0.3),
                                      ),
                                      title: Text(currentChat.interlocutorUserName),
                                      subtitle: Text(currentChat.lastMessage),
                                    ),
                                  );
                                });
                          else
                            return Center(child: Text('Kaydedilmiş konuşma yok.'));
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
}
