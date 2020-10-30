import 'package:flutter/material.dart';
import 'package:live_chat/components/common/custom_bottom_navigation.dart';
import 'package:live_chat/components/pages/profile_page.dart';
import 'package:live_chat/components/pages/users_page.dart';
import 'package:live_chat/views/user_view.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserView _userView;
  TabItem _currentTab = TabItem.Users;

  Map<TabItem, Widget> tabPagesCreator() {
    return {
      TabItem.Users: UsersPage(),
      TabItem.Profile: ProfilePage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    /// Modal Route yardımıyla gönderilen argünmanı yakalama.
    // print(ModalRoute.of(context).settings.arguments);
    _userView = Provider.of<UserView>(context);

    return Container(
        child: _bodyArea(),
    );
  }

  Widget _bodyArea() {
    print(_userView.state);
    if(_userView.state == UserViewState.Idle) {
      return _userView.user == null
          ? Container()
          : CustomBottomNavigation(
              currentTab: _currentTab,
              pageCreator: tabPagesCreator(),
              onSelectedTab: (selectedTab){
                setState(() {
                  _currentTab = selectedTab;
                });
              }
          );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }
}

// _signOut() async {
//   await _userView.signOut();
//   Navigator.of(context).pushReplacementNamed(
//     '/signInPage',
//   );
// }
