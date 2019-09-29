import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medhacks2019app/trial_dispaly.dart';
import 'package:medhacks2019app/trial_select.dart';

class TrialsRoutes {
  static const String trials = '/';
  static const String trial = '/trial';
}

class TrialsPage extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const TrialsPage({
    Key key,
    this.navigatorKey
  }) : super(key: key);

  void _push(BuildContext context, {Map data}) {
    var routeBuilders = _routeBuilders(context, data: data);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => routeBuilders[TrialsRoutes.trial](context),
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, {Map data}) {
    return {
      TrialsRoutes.trials: (context) => TrialSelect(
        mainPage: true,
        onSelected: (data) => _push(context, data: data),
      ),
      TrialsRoutes.trial: (context) => TrialDisplay(data: data)
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);
    return Navigator(
      key: navigatorKey,
      initialRoute: TrialsRoutes.trials,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name](context),
        );
      },
    );
  }

}