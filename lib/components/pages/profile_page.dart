import 'package:flutter/material.dart';
import 'package:live_chat/views/user_view.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserView _userView;

  @override
  Widget build(BuildContext context) {
    _userView = Provider.of<UserView>(context);

    return Scaffold(
      appBar: AppBar(
          title: Text('Profile'),
          actions: [
            FlatButton(
                onPressed: () => _signOut(),
                child: Icon(Icons.logout)
            )
          ],
      ),
      body: Center(
        child: Text('${_userView.user.userEmail}'),
      ),
    );
  }

  _signOut() async {
    _userView.signOut();
    Navigator.of(context, rootNavigator: true).pushReplacementNamed('/signInPage');
  }
}
