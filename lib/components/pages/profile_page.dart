import 'package:flutter/material.dart';
import 'package:live_chat/components/common/alert_dialog_widget.dart';
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
                onPressed: () => _signOutControl(),
                child: Icon(Icons.logout)
            )
          ],
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${_userView.user.userEmail}'),
              RaisedButton(
                child: Text('Show Alert Dialog'),
                onPressed: () {

                  AlertDialogWidget(
                      alertTitle: 'Example Alert Dialog',
                      alertContent: 'Platform Responsive Android / Ios',
                      complateActionText: 'Tamam'
                  ).show(context);

                }
              )
            ],
          ),
        ),
      ),
    );
  }

  Future _signOutControl() async {
    AlertDialogWidget(
        alertTitle: 'Çıkış',
        alertContent: 'Çıkmak istediğinizden emin misiniz?',
        complateActionText: 'Evet',
        cancelActionText: 'Vazgeç',
    ).show(context).then((value) {
      if(value)
        _signOut();
    });
  }

  _signOut() async {
    _userView.signOut();
    Navigator.of(context, rootNavigator: true).pushReplacementNamed('/signInPage');
  }
}
