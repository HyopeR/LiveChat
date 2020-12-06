import 'package:flutter/material.dart';
import 'package:live_chat/components/common/alert_dialog_widget.dart';
import 'package:live_chat/components/common/appbar_widget.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/image_widget.dart';
import 'package:live_chat/components/pages/setting_account_page.dart';
import 'package:live_chat/components/pages/setting_notification_page.dart';
import 'package:live_chat/components/pages/setting_theme_page.dart';
import 'package:live_chat/views/chat_view.dart';
import 'package:live_chat/views/user_view.dart';
import 'package:provider/provider.dart';


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  UserView _userView;
  ChatView _chatView;

  @override
  Widget build(BuildContext context) {
    _userView = Provider.of<UserView>(context);
    _chatView = Provider.of<ChatView>(context);

    return Scaffold(
      appBar: AppbarWidget(
        onLeftSideClick: () => Navigator.of(context).pop(),
        titleText: 'Settings',
        backgroundColor: Theme.of(context).primaryColor,
      ),

      body: SingleChildScrollView(
        child: ContainerColumn(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: InkWell(
                  splashColor: Colors.transparent,
                  child: ImageWidget(
                    backgroundPadding: 0,
                    image: NetworkImage(_userView.user.userProfilePhotoUrl),
                    imageWidth: 75,
                    imageHeight: 75,
                    backgroundShape: BoxShape.circle,
                    backgroundColor: Colors.grey.withOpacity(0.3),
                  ),
                ),
                title: Text(_userView.user.userName),
                subtitle: Text(_userView.user.userEmail),
              ),
            ),

            Divider(thickness: 1),

            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingAccountPage()));
                },
                child: ListTile(
                  leading: Container(width: 75, child: Icon(Icons.vpn_key, color: Theme.of(context).primaryColor.withOpacity(0.6))),
                  title: Text('Hesap'),
                  subtitle: Text('Bilgilerini güncelle'),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingThemePage()));
                },
                child: ListTile(
                  leading: Container(width: 75, child: Icon(Icons.widgets, color: Theme.of(context).primaryColor.withOpacity(0.6))),
                  title: Text('Tema'),
                  subtitle: Text('Tema, duvar kağıdı'),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingNotificationPage()));
                },
                child: ListTile(
                  leading: Container(width: 75, child: Icon(Icons.notifications, color: Theme.of(context).primaryColor.withOpacity(0.6))),
                  title: Text('Bildirim'),
                  subtitle: Text('Mesaj sesleri'),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: InkWell(
                onTap: () {
                  _signOutControl();
                },
                child: ListTile(
                  leading: Container(width: 75, child: Icon(Icons.logout, color: Colors.red)),
                  title: Text('Çıkış Yap'),
                  subtitle: Text('Oturumu kapat'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _signOutControl() async {
    AlertDialogWidget(
      alertTitle: 'Çıkış',
      alertContent: 'Çıkmak istediğinizden emin misiniz?',
      completeActionText: 'Evet',
      cancelActionText: 'Vazgeç',
    ).show(context).then((value) {
      if (value)
        _signOut();
    });
  }
  _signOut() async {
    _userView.logoutUpdate(_userView.user.userId);
    _chatView.clearState();
    _userView.signOut();
    Navigator.of(context, rootNavigator: true).pushReplacementNamed('/signInPage');
  }
}
