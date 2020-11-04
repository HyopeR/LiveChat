import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/title_area.dart';
import 'package:live_chat/views/user_view.dart';
import 'package:provider/provider.dart';

class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  UserView _userView;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getChats();
    });
  }

  @override
  Widget build(BuildContext context) {
    _userView = Provider.of<UserView>(context);

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
                    child: ListView(),
                  ),

                ]
            )
        )
    );
  }

  _getChats() async {
    // var chats = await FirebaseFirestore.instance
    //     .collection('chats')
    //     .where('speaker', isEqualTo: _userView.user.userId)
    //     .orderBy('createdAt', descending: true)
    //     .get();
    //
    // for(var chat in chats.docs) {
    //   print('chat: ' + chat.data().toString());
    // }
  }
}
