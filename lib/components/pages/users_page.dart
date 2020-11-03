import 'package:flutter/material.dart';
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
    getAllUsers();

    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: Center(
        child: Text('Users Page'),
      ),
    );
  }

  Future<List<UserModel>> getAllUsers() async {
    List<UserModel> users = await _userView.getAllUsers();
    print(users);

    return users;
  }
}
