import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:medhacks2019app/globals.dart';

class TrialDisplay extends StatelessWidget {
  final Map<String, dynamic> data;

  const TrialDisplay({
    Key key,
    @required this.data
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Inspect Trial")
      ),
      body: Column(
        children: <Widget>[
          Text("Name: " + data['name']),
          Text("Contact: " + data['contact']),
          Text("Description: " + data['description']),
        ]
      )
    );

  }
}