import 'package:flutter/material.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/image_widget.dart';
import 'package:live_chat/components/common/title_area.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/views/user_view.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  UserView _userView;

  @override
  Widget build(BuildContext context) {
    _userView = Provider.of<UserView>(context);

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
                future: getAllUsers(),
                builder: (context, futureResult) {

                  if(futureResult.hasData) {
                    List<UserModel> users = futureResult.data;

                    if(users.length > 0)
                      return ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {

                            UserModel currentUser = users[index];

                            if(currentUser.userId != _userView.user.userId)
                              return ListTile(
                                onTap: () {},
                                leading: ImageWidget(
                                  imageUrl: currentUser.userProfilePhotoUrl,
                                  imageWidth: 75,
                                  imageHeight: 75,
                                  backgroundShape: BoxShape.circle,
                                  backgroundColor: Colors.grey.withOpacity(0.3),
                                ),
                                title: Text(currentUser.userName),
                                subtitle: Text(currentUser.userEmail),
                              );
                            else
                              return Container();

                          }
                      );
                    else
                      return Center(child: Text('Kayıtlı kullanıcı bulunmamaktadır.'));

                  } else
                    return Center(child: CircularProgressIndicator());
                },
              ),
            )

          ],
        ),
      )
    );
  }

  Future<List<UserModel>> getAllUsers() async {
    List<UserModel> users = await _userView.getAllUsers();
    print(users);

    return users;
  }
}
