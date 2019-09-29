import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medhacks2019app/folder_images.dart';
import 'package:medhacks2019app/folder_select.dart';

class ImagesRoutes {
  static const String folders = '/';
  static const String images = '/images';
}

class ImagesPage extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const ImagesPage({
    Key key,
    this.navigatorKey
  }) : super(key: key);

  void _push(BuildContext context, {String folder: 'None'}) {
    var routeBuilders = _routeBuilders(context, folder: folder);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => routeBuilders[ImagesRoutes.images](context),
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, {String folder: 'None'}) {
    return {
      ImagesRoutes.folders: (context) => FolderSelect(
        mainPage: true,
        onSelected: (folder) =>
            _push(context, folder: folder),
      ),
      ImagesRoutes.images: (context) => FolderImages(folder: folder)
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);
    return Navigator(
      key: navigatorKey,
      initialRoute: ImagesRoutes.folders,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name](context),
        );
      },
    );
  }

}