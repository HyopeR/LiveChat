import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  User _user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _checkUser(context);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  Text('Live Chat with Flutter', style: TextStyle(fontSize: Theme.of(context).textTheme.headline6.fontSize),),
                ],
              ),
            ),
          ),
        )
    );
  }

  Future<void> _checkUser(BuildContext context) async {
    _user = FirebaseAuth.instance.currentUser;
    // print((_user == null).toString());

    if(_user == null) {
      Future.delayed(
          Duration(seconds: 2),
          () {
            Navigator.of(context).pushReplacementNamed(
              '/signInPage',
            );
          }
      );
    } else {
      Future.delayed(
          Duration(seconds: 2),
          () {
            Navigator.of(context).pushReplacementNamed(
              '/homePage',
              arguments: _user
            );
          }
      );
    }

  }
}
