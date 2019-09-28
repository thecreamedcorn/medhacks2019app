import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'home_widget.dart';

Future<void> main() async {
  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyApp({
    Key key,
    @required this.cameras,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kira',
      home: Home(cameras: cameras),
    );
  }
}