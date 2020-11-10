import 'package:flutter/material.dart';
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
                  FlutterLogo(
                    size: 128,
                    textColor: Colors.amber,
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
            Navigator.of(context).pushReplacementNamed(
              '/signInPage',
            );
          }
      );
    } else {
      _userView.streamCurrentUser(_userView.user.userId);
      await _chatView.getAllUsers();
      _chatView.getAllGroups(_userView.user.userId);

      Future.delayed(
          Duration(seconds: 2),
          () {
            Navigator.of(context).pushReplacementNamed(
              '/homePage',
            );
          }
      );
    }

  }
}
