import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:medhacks2019app/bottom_navigation.dart';
import 'package:medhacks2019app/camera_page.dart';
import 'package:medhacks2019app/images_page.dart';
import 'package:medhacks2019app/trials_page.dart';

class Home extends StatefulWidget {
  final List<CameraDescription> cameras;

  const Home({
    Key key,
    @required this.cameras,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  Map<TabItem, GlobalKey<NavigatorState>> _navigatorKeys = {
    TabItem.images: GlobalKey<NavigatorState>(),
    TabItem.camera: GlobalKey<NavigatorState>(),
    TabItem.trials: GlobalKey<NavigatorState>(),
  };
  TabItem _currentTab = TabItem.images;

  @override
  void initState() {
  }

  void _selectTab(TabItem tabItem) {
    if (tabItem == _currentTab && _navigatorKeys.containsKey(tabItem)) {
      // pop to first route
      _navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab = await _navigatorKeys[_currentTab].currentState.maybePop();

        if (isFirstRouteInCurrentTab) {
          // if not on the 'main' tab
          if (_currentTab != TabItem.images) {
            // select 'main' tab
            _selectTab(TabItem.images);
            // back button handled by app
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: Stack(children: <Widget>[
          Offstage(
            offstage: _currentTab != TabItem.images,
            child: ImagesPage(
              navigatorKey: _navigatorKeys[TabItem.images],
            ),
          ),
          Offstage(
            offstage: _currentTab != TabItem.camera,
            child: CameraPage(
              cameras: widget.cameras,
              navigatorKey: _navigatorKeys[TabItem.camera],
            ),
          ),
          Offstage(
            offstage: _currentTab != TabItem.trials,
            child: TrialsPage(
              navigatorKey: _navigatorKeys[TabItem.trials],
            ),
          ),
        ]),
        bottomNavigationBar: BottomNavigation(
          currentTab: _currentTab,
          onSelectTab: _selectTab,
        ),
      )
    );
  }
}