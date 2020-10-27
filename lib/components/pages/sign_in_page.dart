import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:live_chat/components/common/login_button.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/views/user_view.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  UserView _userView;

  @override
  Widget build(BuildContext context) {
    _userView = Provider.of<UserView>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        elevation: 0,
      ),

      body: bodyArea(),
    );
  }

  Widget bodyArea() {
    return _userView.state == UserViewState.Idle
      ? Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Text(
                'Oturum Açma Yöntemleri',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24)
            ),

            SizedBox(height: 10),

            LoginButton(
              buttonText: 'Google ile Oturum Aç',
              textColor: Colors.black,
              textSize: Theme.of(context).textTheme.headline6.fontSize,

              buttonRadius: 16,
              buttonColor: Colors.white,

              icon: Image.asset('assets/images/google-logo.png'),
              onPressed: (){},
            ),

            LoginButton(
              buttonText: 'Facebook ile Oturum Aç',
              textColor: Colors.white,
              textSize: Theme.of(context).textTheme.headline6.fontSize,

              buttonRadius: 16,
              buttonColor: Color(0xFF334D92),

              icon: Image.asset('assets/images/facebook-logo.png'),
              onPressed: (){},
            ),

            LoginButton(
              buttonText: 'Email ve Şifre ile Oturum Aç',
              textColor: Colors.white,
              textSize: Theme.of(context).textTheme.headline6.fontSize,

              buttonRadius: 16,
              buttonColor: Colors.grey,

              icon: Icon(Icons.email, color: Colors.white, size: 34,),
              onPressed: (){},
            ),

            LoginButton(
              buttonText: 'Misafir olarak Oturum Aç',
              textColor: Colors.white,
              textSize: Theme.of(context).textTheme.headline6.fontSize,

              buttonRadius: 16,
              buttonColor: Colors.orange,

              icon: Icon(Icons.person, color: Colors.white, size: 34,),
              onPressed: () => visitorLogin(context),
            )

          ],
        ),
      )
      : Center(child: CircularProgressIndicator());
  }

  void visitorLogin(BuildContext context) async {
    UserModel user = await _userView.signInAnonymously();

    if(user != null) {
      Navigator.of(context).pushReplacementNamed(
          '/homePage',
          arguments: user
      );
    } else {
      print('Hata oluştu.');
    }


  }
}
