import 'package:flutter/material.dart';
import 'package:live_chat/components/common/custom_bottom_navigation.dart';
import 'package:live_chat/components/pages/chats_page.dart';
import 'package:live_chat/components/pages/profile_page.dart';
import 'package:live_chat/components/pages/users_page.dart';
import 'package:live_chat/views/user_view.dart';
import 'package:provider/provider.dart';
import 'package:swipedetector/swipedetector.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  GlobalKey<CustomBottomNavigationState> _customBottomNavigationState = GlobalKey();
  UserView _userView;

  List tabsKeys = TabItem.values;
  TabItem _currentTab = TabItem.Chats;

  Map<TabItem, GlobalKey<NavigatorState>> tabNavigatorKeys = {
    TabItem.Chats : GlobalKey<NavigatorState>(),
    TabItem.Users : GlobalKey<NavigatorState>(),
    TabItem.Profile : GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> tabPagesCreator() {
    return {
      TabItem.Chats: ChatsPage(),
      TabItem.Users: UsersPage(),
      TabItem.Profile: ProfilePage(),
    };
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.paused) {
      // Kullanıcı uygulamayı arka plana attı. Online durumunu güncelle. (false)
      _userView.logoutUpdate(_userView.user.userId);
    }

    if(state == AppLifecycleState.resumed) {
      // Kullanıcı online olmaya devam ediyor. Online durumunu güncelle. (true)
      _userView.loginUpdate(_userView.user.userId);
    }

  }

  @override
  Widget build(BuildContext context) {
    _userView = Provider.of<UserView>(context);

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => !await tabNavigatorKeys[_currentTab].currentState.maybePop(),
        child: Container(
          child: _bodyArea(),
        ),
      ),
    );
  }

  Widget _bodyArea() {
    if(_userView.state == UserViewState.Idle) {
      if(_userView.user == null) {
        return _busyArea();
      } else {
        return SwipeDetector(
          onSwipeLeft: () {
            swipeTab('leftSwipe');
          },

          onSwipeRight: () {
            swipeTab('rightSwipe');
          },

          child: CustomBottomNavigation(
              key: _customBottomNavigationState,
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
          ),
        );
      }
    } else {
      return _busyArea();
    }
  }

  swipeTab(String swipeType) {
    switch(swipeType) {

      case('rightSwipe'):
        if(_customBottomNavigationState.currentState.tabController.index > 0) {
          int targetIndex = _customBottomNavigationState.currentState.tabController.index - 1;
          _customBottomNavigationState.currentState.tabController.index = targetIndex;

          setState(() {
            _currentTab = tabsKeys[targetIndex];
          });
        }
        break;

      case('leftSwipe'):
        if(_customBottomNavigationState.currentState.tabController.index < 2) {
          int targetIndex = _customBottomNavigationState.currentState.tabController.index + 1;
          _customBottomNavigationState.currentState.tabController.index = targetIndex;

          setState(() {
            _currentTab = tabsKeys[targetIndex];
          });
        }
        break;

      default:
        break;

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
