import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem { Users, Profile }
class TabItemData {

  final String label;
  final IconData icon;

  TabItemData(this.label, this.icon);

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.Users : TabItemData('Users', Icons.people),
    TabItem.Profile : TabItemData('Profile', Icons.person),
  };
}

class CustomBottomNavigation extends StatelessWidget {

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  const CustomBottomNavigation({Key key, @required this.currentTab, @required this.onSelectedTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(

      tabBar: CupertinoTabBar(
        items: [
          _createNavigationItem(TabItem.Users),
          _createNavigationItem(TabItem.Profile)
        ],
      ),

      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) => Container(
            child: Text('Page ${index.toString()}'),
          ),
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
