import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ViewImage extends StatelessWidget {
  final String date;
  final String path;

  const ViewImage({
    Key key,
    this.date,
    this.path
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(date),
      ),
      body: Container (
        color: Colors.black,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                alignment: FractionalOffset.center,
                image: Image.file(File(path)).image,
              )
            ),
          )
        )
      )
    );
  }

}