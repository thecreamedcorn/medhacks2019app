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
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 2,
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Text(data['name'],
                    style: TextStyle(
                      fontSize: 25
                    )
                  )
                ),
              )
            ),
            SizedBox(height: 15),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Contact: " + data['contact'],
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 5),
            Row(children: <Widget>[Expanded(child: Divider())]),
            SizedBox(height: 5),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Description: " + data['description'],
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ]
        )
      )
    );

  }
}