import 'package:flutter/material.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/container_row.dart';
import 'package:live_chat/components/common/image_widget.dart';
import 'package:live_chat/components/common/title_area.dart';
import 'package:live_chat/components/pages/chat_page.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/views/chat_view.dart';
import 'package:live_chat/views/user_view.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  UserView _userView;
  ChatView _chatView;

  @override
  Widget build(BuildContext context) {
    _userView = Provider.of<UserView>(context);
    _chatView = Provider.of<ChatView>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Users'),
        ),
        body: SafeArea(
          child: ContainerColumn(
            padding: EdgeInsets.all(10),
            children: [
              TitleArea(titleText: 'Tüm Kullanıcılar', icon: Icons.people),
              Expanded(
                child: FutureBuilder<List<UserModel>>(
                  future: _chatView.getAllUsers(),
                  builder: (context, futureResult) {
                    if (futureResult.hasData) {
                      List<UserModel> users = futureResult.data;

                      if (users.length - 1 > 0)
                        return RefreshIndicator(
                          onRefresh: () => refreshUsers(),
                          child: ListView.builder(
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                UserModel currentUser = users[index];

                                if ((currentUser.userId != _userView.user.userId))
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .push(MaterialPageRoute(builder: (context) =>
                                          ChatPage(currentUser: _userView.user, chatUser: currentUser)));
                                    },
                                    child: ListTile(
                                      leading: ImageWidget(
                                        imageUrl: currentUser.userProfilePhotoUrl,
                                        imageWidth: 75,
                                        imageHeight: 75,
                                        backgroundShape: BoxShape.circle,
                                        backgroundColor: Colors.grey.withOpacity(0.3),
                                      ),
                                      title: Text(currentUser.userName),
                                      subtitle: Text(currentUser.userEmail),
                                    ),
                                  );
                                else
                                  return Container();
                              }),
                        );
                      else
                        return RefreshIndicator(
                          onRefresh: () => refreshUsers(),
                          child: SizedBox.expand(
                            child: ListView(
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.people, size: 100),
                                    Text(
                                      'Kayıtlı kullanıcı bulunmamaktadır.',
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                    } else
                      return Center(child: CircularProgressIndicator());
                  },
                ),
              )
            ],
          ),
        ));
  }

  refreshUsers() async {
    await Future.delayed(Duration(seconds: 2), () {
      setState(() {});
    });
  }
}
