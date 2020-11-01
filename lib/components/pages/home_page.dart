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

  Map<TabItem, GlobalKey<NavigatorState>> tabNavigatorKeys = {
    TabItem.Users : GlobalKey<NavigatorState>(),
    TabItem.Profile : GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> tabPagesCreator() {
    return {
      TabItem.Users: UsersPage(),
      TabItem.Profile: ProfilePage(),
    };
  }

  @override
  Widget build(BuildContext context) {

    _userView = Provider.of<UserView>(context);
    print('HOME BUILD:' + _userView.user.toString());

    return WillPopScope(
      onWillPop: () async => !await tabNavigatorKeys[_currentTab].currentState.maybePop(),
      child: Container(
          child: _bodyArea(),
      ),
    );
  }

  Widget _bodyArea() {
    if(_userView.state == UserViewState.Idle) {
      if(_userView.user == null) {
        return _busyArea();
      } else {
        return CustomBottomNavigation(
            currentTab: _currentTab,
            pageCreator: tabPagesCreator(),
            navigatorKeys: tabNavigatorKeys,
            onSelectedTab: (selectedTab){

              /// Eğer ilerlenmiş bi rotada aynı rota seçilirse başlangıcına dönmesi için kontrol.
              if(selectedTab == _currentTab)
                tabNavigatorKeys[selectedTab].currentState.popUntil((route) => route.isFirst);
              else
                setState(() {
                  _currentTab = selectedTab;
                });
            }
        );
      }
    } else {
      return _busyArea();
    }
  }

  Widget _busyArea() {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black38.withOpacity(0.5),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('İşlem yapılıyor...'),
                SizedBox(height: 20),
                CircularProgressIndicator()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
