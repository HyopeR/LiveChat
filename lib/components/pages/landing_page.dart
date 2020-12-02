import 'package:flutter/material.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/views/chat_view.dart';
import 'package:live_chat/views/user_view.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  UserView _userView;
  ChatView _chatView;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _checkUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    _userView = Provider.of<UserView>(context);
    _chatView = Provider.of<ChatView>(context);

    return Scaffold(

        body: SafeArea(
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 128,
                    height: 128,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/live_chat_logo.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Live Chat with Flutter', style: TextStyle(fontSize: Theme.of(context).textTheme.headline6.fontSize)),
                ],
              ),
            ),
          ),
        )
    );
  }

  Future<void> _checkUser() async {
    await _userView.getCurrentUser();

    if(_userView.user == null) {
      Future.delayed(
          Duration(seconds: 2),
          () {
            Navigator.of(context, rootNavigator: true).pushReplacementNamed(
              '/signInPage',
            );
          }
      );
    } else {
      UserModel user = await _userView.streamCurrentUser(_userView.user.userId).first;
      await _userView.loginUpdate(user.userId);
      await _chatView.getAllUsers().first;
      // _chatView.contacts = await _chatView.getAllContacts(user.contacts).first;
      await _chatView.getAllGroups(user.userId).first;

      Future.delayed(
          Duration(seconds: 2),
          () {
            Navigator.of(context, rootNavigator: true).pushReplacementNamed(
              '/homePage',
            );
          }
      );
    }

  }
}
