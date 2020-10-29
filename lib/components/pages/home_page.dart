import 'package:flutter/material.dart';
import 'package:live_chat/components/common/custom_bottom_navigation.dart';
import 'package:live_chat/views/user_view.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserView _userView;
  TabItem _currentTab = TabItem.Users;

  @override
  Widget build(BuildContext context) {
    /// Modal Route yardımıyla gönderilen argünmanı yakalama.
    // print(ModalRoute.of(context).settings.arguments);
    _userView = Provider.of<UserView>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Ana Sayfa'),
        elevation: 0,

        actions: [
          IconButton(
            splashRadius: 25,
            icon: Icon(Icons.logout),
            onPressed: () => _signOut(),
          )
        ],
      ),

      body: Container(
        child: _bodyArea(),
      ),
    );
  }

  Widget _bodyArea() {
    if(_userView.state == UserViewState.Idle) {
      return _userView.user == null
          ? Container()
          : CustomBottomNavigation(
              currentTab: _currentTab,
              onSelectedTab: (selectedTab){
                debugPrint('Seçilen Tab: ${selectedTab.toString()}');
              }
          );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  _signOut() async {
    await _userView.signOut();
    Navigator.of(context).pushReplacementNamed(
      '/signInPage',
    );
  }
}
