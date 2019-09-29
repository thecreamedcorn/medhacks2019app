import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medhacks2019app/camera_widget.dart';

class CameraPage extends StatelessWidget {
  final List<CameraDescription> cameras;
  final GlobalKey<NavigatorState> navigatorKey;

  const CameraPage({
    Key key,
    this.cameras,
    this.navigatorKey
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CameraWidget(cameras: cameras);
  }
}