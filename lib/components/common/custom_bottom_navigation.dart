import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_chat/components/common/container_column.dart';

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

class CustomBottomNavigation extends StatefulWidget {

  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, Widget> pageCreator;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  const CustomBottomNavigation({
    Key key,
    @required this.onSelectedTab,
    @required this.pageCreator,
    @required this.navigatorKeys
  }) : super(key: key);

  @override
  CustomBottomNavigationState createState() => CustomBottomNavigationState();
}

class CustomBottomNavigationState extends State<CustomBottomNavigation> {
  CupertinoTabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = CupertinoTabController(initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(

      controller: tabController,
      tabBar: CupertinoTabBar(
        // backgroundColor: Color(0xFFf7fbf7),
        backgroundColor: Colors.grey.shade300.withOpacity(0.8),

        inactiveColor: Colors.black54,

        border: Border(bottom: BorderSide(color: Colors.transparent)),
        iconSize: 28,

        items: [
          _createNavigationItem(TabItem.Users),
          _createNavigationItem(TabItem.Chats),
          _createNavigationItem(TabItem.Profile),
        ],

        onTap: (index) {
          widget.onSelectedTab(TabItem.values[index]);
        },
      ),

      tabBuilder: (context, index) {
        final showItem = TabItem.values[index];

        return CupertinoTabView(
          navigatorKey: widget.navigatorKeys[showItem],
          builder: (context) => widget.pageCreator[showItem],
        );
      },

    );
  }

  BottomNavigationBarItem _createNavigationItem(TabItem tabItem) {
    final createdCurrentTab = TabItemData.allTabs[tabItem];
    return BottomNavigationBarItem(

      icon: SizedBox.expand(
        child: ContainerColumn(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(createdCurrentTab.icon),
            Text(createdCurrentTab.label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),)
          ],
        ),
      ),
    );
  }
}
