import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/app/home/tab_item.dart';

class CupertinoHomeScaffold extends StatelessWidget {
  const CupertinoHomeScaffold(
      {required this.currentTab,
        required this.onSelectTab,
        required this.widgetBuilders,
        required this.navigatorKeys,
        Key? key})
      : super(key: key);
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;
  final Map<TabItem, WidgetBuilder> widgetBuilders;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;


  @override
  Widget build(BuildContext context) {
    // return BottomNavigationBar(items:[],
    // onTap: (index) => onSelectTab(TabItem.values[index]),);
    // CupertinoTabScaffold is used because we want to use multiple stack.
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _buildItem(TabItem.jobs),
          _buildItem(TabItem.entries),
          _buildItem(TabItem.accounts),
        ],
        onTap: (index) => onSelectTab(TabItem.values[index]),
      ),
      tabBuilder: (BuildContext context, int index) {
        final item = TabItem.values[index];
        return CupertinoTabView(
          builder: (context) => widgetBuilders[item]!(context),
          navigatorKey: navigatorKeys[item],
        );
      },
    );

  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemData = TabItemData.allTabs[tabItem];
    final color = currentTab == tabItem ? Colors.blue : Colors.grey;
    return BottomNavigationBarItem(
      icon: Icon(
        itemData?.icon,
        color: color,
      ),
      label: itemData?.label,
    );
  }
}
