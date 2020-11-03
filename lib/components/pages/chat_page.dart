import 'package:flutter/material.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/container_row.dart';
import 'package:live_chat/components/common/message_creator_widget.dart';
import 'package:live_chat/models/chat_model.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/views/user_view.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final UserModel currentUser;
  final UserModel chatUser;

  const ChatPage({Key key, this.currentUser, this.chatUser}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  UserView _userView;
  GlobalKey<MessageCreatorWidgetState> _messageCreatorState = GlobalKey();

  @override
  Widget build(BuildContext context) {
    _userView = Provider.of<UserView>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Chat'),
        ),
        body: SafeArea(
          child: ContainerColumn(
            padding: EdgeInsets.all(10),
            children: [
              Expanded(
                child: StreamBuilder<List<ChatModel>>(
                  stream: _userView.getMessages(widget.currentUser.userId, widget.chatUser.userId),
                  builder: (context, streamData){

                    List<ChatModel> messages = streamData.data;

                    if(messages != null) {
                      if(messages.isNotEmpty)
                        return ListView.builder(
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              return Text(messages[index].message);
                            }
                        );

                      else
                        return Center(child: Text('Bir konuşma başlat'));
                    } else
                      return Container();

                  },
                )
              ),

              MessageCreatorWidget(
                hintText: 'Bir mesaj yazın.',
                textAreaColor: Colors.grey.withOpacity(0.3),
                buttonColor: Theme.of(context).primaryColor,
                onPressed: () {

                },
              )
            ],
          ),
        ));
  }
}
