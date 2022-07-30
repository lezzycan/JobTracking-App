import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem { jobs, entries, accounts }

class TabItemData {
  const TabItemData({required this.label, required this.icon});
  final String label;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.jobs: TabItemData(label: 'jobs', icon: Icons.work),
    TabItem.entries: TabItemData(label: 'entries', icon: Icons.view_headline),
    TabItem.accounts: TabItemData(label: 'accounts', icon: Icons.person),
  };
}
