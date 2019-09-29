import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:medhacks2019app/globals.dart';

AppBar kiraAppBar(BuildContext context) {
  return AppBar(
    title: Text("Kira"),
    actions: <Widget>[
      FlatButton.icon(
        textColor: Colors.white,
        icon: Icon(Icons.person_outline),
        label: Text('User'),
        onPressed: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("User Code"),
                content: Column(
                  children: <Widget>[
                    Text('Email: wgaboury@gmail.com'),
                    Text('ID: a57u8bw57nt7n83'),
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    ],
  );
  }