import 'package:flutter/material.dart';
import 'package:live_chat/components/common/appbar_widget.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/image_widget.dart';
import 'package:live_chat/components/common/title_area.dart';
import 'package:live_chat/components/common/user_dialog_widget.dart';
import 'package:live_chat/components/pages/chat_page.dart';
import 'package:live_chat/components/pages/profile_photo_show_page.dart';
import 'package:live_chat/components/pages/search_user_page.dart';
import 'package:live_chat/components/pages/user_preview_page.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/services/operation_service.dart';
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

  GlobalKey<AppbarWidgetState> _appbarWidgetState = GlobalKey();

  List<UserModel> users;
  List<String> selectedUserIdList = List<String>();

  @override
  Widget build(BuildContext context) {
    _userView = Provider.of<UserView>(context);
    _chatView = Provider.of<ChatView>(context);

    return Scaffold(
        appBar: AppbarWidget(
          key: _appbarWidgetState,
          titleText: 'Live Chat',
          actions: [
            FlatButton(
                minWidth: 50,
                child: Icon(Icons.search),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchUserPage())).then((updatedContacts) {
                      if(updatedContacts)
                        setState(() {});
                })
            )
          ],
          operationActions: createOperationActions(),
          onOperationCancel: () {
            setState(() {
              selectedUserIdList.clear();
            });
          },
        ),
        body: WillPopScope(
          onWillPop: () async {
            if (_appbarWidgetState.currentState.operation) {
              _appbarWidgetState.currentState.operationCancel();
              setState(() {
                selectedUserIdList.clear();
              });
            }

            return false;
          },
          child: SafeArea(
            child: ContainerColumn(
              padding: EdgeInsets.all(10),
              children: [
                TitleArea(titleText: 'Kişilerim', icon: Icons.people),
                Expanded(
                  child: StreamBuilder<List<UserModel>>(
                    stream: _chatView.getAllContacts(_userView.contactsIdList),
                    builder: (context, streamData) {

                      if (streamData.hasData) {
                        users = streamData.data;

                        if (streamData.data.isNotEmpty) {
                          return RefreshIndicator(
                            onRefresh: () => refreshUsers(),
                            child: ListView.builder(
                                itemCount: users.length,
                                itemBuilder: (context, index) => createItem(index)
                            ),
                          );
                        } else {
                          return LayoutBuilder(
                            builder: (context, constraints) => RefreshIndicator(
                                onRefresh: () => refreshUsers(),
                                child: SingleChildScrollView(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                          minHeight: constraints.maxHeight),
                                      child: ContainerColumn(
                                        alignment: Alignment.center,
                                        children: [
                                          Icon(Icons.people, size: 100),
                                          Text(
                                            'Kayıtlı kullanıcı bulunmamaktadır.',
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                    ))),
                          );
                        }
                      } else
                        return Center(child: CircularProgressIndicator());
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }

  refreshUsers() async {
    await Future.delayed(Duration(seconds: 2), () {
      setState(() {});
    });
  }

  Widget createItem(int index) {
    UserModel currentUser = users[index];
    bool selected = selectedUserIdList.contains(currentUser.userId);

    if ((currentUser.userId != _userView.user.userId)) {
      return Container(
        margin: EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          color: selected
              ? Colors.grey.withOpacity(0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            _chatView.findChatByUserIdList([
              _userView.user.userId,
              currentUser.userId
            ]);

            _chatView.interlocutorUser = currentUser;
            _chatView.groupType = 'Private';
            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => ChatPage()));
          },
          onLongPress: () {
            if (selected) {
              setState(() {
                selectedUserIdList.removeWhere((userId) => userId == currentUser.userId);
              });

              if (selectedUserIdList.length == 0)
                _appbarWidgetState.currentState.operationCancel();
            } else {
              setState(() {
                selectedUserIdList.add(currentUser.userId);
              });

              _appbarWidgetState.currentState.operationOpen();
            }
          },
          child: ListTile(
            leading: InkWell(
              onTap: () {
                UserDialogWidget(
                  name: currentUser.userName,
                  photoUrl: currentUser.userProfilePhotoUrl,

                  onPhotoClick: () {
                    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => ProfilePhotoShowPage()));
                  },

                  onChatClick: () {
                    _chatView.findChatByUserIdList([
                      _userView.user.userId,
                      currentUser.userId
                    ]);

                    _chatView.interlocutorUser = currentUser;
                    _chatView.groupType = 'Private';
                    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => ChatPage()));
                  },

                  onDetailClick: () async {
                    _chatView.groupType = 'Private';
                    _chatView.interlocutorUser = currentUser;
                    Color userColor = await getDynamicColor(_chatView.interlocutorUser.userProfilePhotoUrl);
                    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => UserPreviewPage(color: userColor)));
                  },
                ).show(context);
              },
              child: ImageWidget(
                imageUrl: currentUser.userProfilePhotoUrl,
                imageWidth: 75,
                imageHeight: 75,
                backgroundShape: BoxShape.circle,
                backgroundColor:
                Colors.grey.withOpacity(0.3),
              ),
            ),
            title: Text(currentUser.userName),
            subtitle: Text(currentUser.userEmail),
          ),
        ),
      );
    } else
      return Container();

  }

  List<Widget> createOperationActions() {
    return [
      selectedUserIdList.length > 0
          ? Container(
              alignment: Alignment.center,
              width: 50,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black.withOpacity(0.1),
                  ),
                  padding: EdgeInsets.all(5),
                  child: Text(selectedUserIdList.length.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20))))
          : Container(),

      selectedUserIdList.length == 1
          ? FlatButton(
              minWidth: 50,
              child: Icon(Icons.remove_red_eye),
              onPressed: () {
                _chatView.findChatByUserIdList([
                  _userView.user.userId,
                  selectedUserIdList[0]
                ]);

                _chatView.interlocutorUser = _chatView.selectChatUser(selectedUserIdList[0]);
                _chatView.groupType = 'Private';

                _appbarWidgetState.currentState.operationCancel();
                selectedUserIdList.clear();
                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => ChatPage()));
              })
          : Container(),

      FlatButton(minWidth: 50, child: Text('Yeni Grup'), onPressed: () {})
    ];
  }
}
