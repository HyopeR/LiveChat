import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:live_chat/components/common/login_button.dart';
import 'package:live_chat/components/common/login_form.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/views/user_view.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  UserView _userView;
  bool showForm = false;

  GlobalKey<LoginFormState> _loginFormState = GlobalKey();


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
        child: ListView(
          children: [
            Column(
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
                  onPressed: () => googleLogin(),
                ),

                LoginButton(
                  buttonText: 'Facebook ile Oturum Aç',
                  textColor: Colors.white,
                  textSize: Theme.of(context).textTheme.headline6.fontSize,

                  buttonRadius: 16,
                  buttonColor: Color(0xFF334D92),

                  icon: Image.asset('assets/images/facebook-logo.png'),
                  onPressed: () => facebookLogin(),
                ),

                LoginButton(
                  buttonText: 'Email ve Şifre ile Oturum Aç',
                  textColor: Colors.white,
                  textSize: Theme.of(context).textTheme.headline6.fontSize,

                  buttonRadius: 16,
                  buttonColor: Colors.orange,

                  icon: Icon(Icons.email, color: Colors.white, size: 34,),
                  onPressed: () => setState(() => showForm = !showForm),
                ),

                showForm
                    ? LoginForm(
                        key: _loginFormState,
                        formElementsRadius: 16,
                        formElementsHeight: 50,
                        onPressed: () => emailAndPasswordLogin(),
                    )
                    : Container(),

                LoginButton(
                  buttonText: 'Misafir olarak Oturum Aç',
                  textColor: Colors.white,
                  textSize: Theme.of(context).textTheme.headline6.fontSize,

                  buttonRadius: 16,
                  buttonColor: Colors.grey,

                  icon: Icon(Icons.person, color: Colors.white, size: 34,),
                  onPressed: () => visitorLogin(),
                )

              ],
            )
          ],
        ),
      )
      : Center(child: CircularProgressIndicator());
  }

  void visitorLogin() async {
    UserModel user = await _userView.signInAnonymously();

    if(user != null) {
      Navigator.of(context).pushReplacementNamed(
          '/homePage',
          arguments: user
      );
    } else
        print('User nesnesi boş.');


  }

  void googleLogin() async {
    UserModel user = await _userView.signInWithGoogle();

    if(user != null) {
      Navigator.of(context).pushReplacementNamed(
          '/homePage',
          arguments: user
      );
    } else
        print('User nesnesi boş.');


  }


  void facebookLogin() async {
    UserModel user = await _userView.signInWithFacebook();

    if(user != null) {
      Navigator.of(context).pushReplacementNamed(
          '/homePage',
          arguments: user
      );
    } else
      print('User nesnesi boş.');

  }


  void emailAndPasswordLogin() async {
    _loginFormState.currentState.formSubmit();
    String email = _loginFormState.currentState.email;
    String password = _loginFormState.currentState.password;

    UserModel user = _loginFormState.currentState.formType == FormType.Login
      ? await _userView.signInWithEmailAndPassword(email, password)
      : await _userView.createUserEmailAndPassword(email, password);

    if(user != null) {
      Navigator.of(context).pushReplacementNamed(
          '/homePage',
          arguments: user
      );
    } else
      print('User nesnesi boş.');

  }
}
