import 'package:flutter/material.dart';

enum TabItem { images, camera, trials }

Map<TabItem, String> tabName = {
  TabItem.images: 'Images',
  TabItem.camera: 'Camera',
  TabItem.trials: 'Trials',
};

Map<TabItem, Icon> tabIcons = {
  TabItem.images: new Icon(Icons.folder),
  TabItem.camera: new Icon(Icons.camera_alt),
  TabItem.trials: new Icon(Icons.format_color_fill)
};

Map<TabItem, int> tabItemIndex = {
  TabItem.images: 0,
  TabItem.camera: 1,
  TabItem.trials: 2
};

class BottomNavigation extends StatelessWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  BottomNavigation({
    this.currentTab,
    this.onSelectTab
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: tabItemIndex[currentTab],
      items: [
        _buildItem(tabItem: TabItem.images),
        _buildItem(tabItem: TabItem.camera),
        _buildItem(tabItem: TabItem.trials),
      ],
      onTap: (index) => onSelectTab(TabItem.values[index])
    );
  }

  BottomNavigationBarItem _buildItem({TabItem tabItem}) {
    String text = tabName[tabItem];
    Icon icon = tabIcons[tabItem];
    return BottomNavigationBarItem(
      icon: icon,
      title: Text(text)
    );
  }
}