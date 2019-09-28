import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'camera_page.dart';
import 'tab_change1.dart';

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
  List<Widget> _children;
  int _currentIndex = 0;

  @override
  void initState() {
    _children = [
      TabChange1(Colors.white),
      CameraPage(cameras: widget.cameras),
      TabChange1(Colors.red)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Flutter App'),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.folder),
            title: new Text('Images'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.camera_alt),
            title: new Text('Camera'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.format_color_fill),
              title: Text('Trials')
          )
        ],
      ),
    );
  }

  void onTabTapped(int index){
    setState(() {
      _currentIndex = index;
    });
  }
}