import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem { Users, Chats, Profile }
class TabItemData {

  final String label;
  final IconData icon;

  TabItemData(this.label, this.icon);

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.Users : TabItemData('Users', Icons.people),
    TabItem.Chats : TabItemData('Chats', Icons.chat),
    TabItem.Profile : TabItemData('Profile', Icons.person),
  };
}

class CustomBottomNavigation extends StatelessWidget {

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, Widget> pageCreator;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  const CustomBottomNavigation({
    Key key,
    @required this.currentTab,
    @required this.onSelectedTab,
    @required this.pageCreator,
    @required this.navigatorKeys
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Custom Bottom: ' + Navigator.of(context).toString());
    return CupertinoTabScaffold(

      tabBar: CupertinoTabBar(
        items: [
          _createNavigationItem(TabItem.Users),
          _createNavigationItem(TabItem.Chats),
          _createNavigationItem(TabItem.Profile)
        ],

        onTap: (index) => onSelectedTab(TabItem.values[index]),
      ),

      tabBuilder: (context, index) {

        final showItem = TabItem.values[index];

        return CupertinoTabView(
          navigatorKey: navigatorKeys[showItem],
          builder: (context) => pageCreator[showItem],
        );
      },

    );
  }


  BottomNavigationBarItem _createNavigationItem(TabItem tabItem) {
    
    final createdCurrentTab = TabItemData.allTabs[tabItem];
    
    return BottomNavigationBarItem(
      label: createdCurrentTab.label,
      icon: Icon(createdCurrentTab.icon),
    );
  }
}
