import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medhacks2019app/globals.dart';
import 'package:http/http.dart' as http;

class FolderSelect extends StatefulWidget {
  @override
  _FolderSelectState createState() {
    return _FolderSelectState();
  }

}

class _FolderSelectState extends State<FolderSelect> {
  Future<List<String>> _foldersFuture;

  @override
  void initState() {
    super.initState();

    _foldersFuture = _getFolders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Folder'),
      ),
//      body: FutureBuilder(
//        future: _foldersFuture,
//        builder: (context, snapshot) {
//          return List.bu
//        },
//      )
    );
  }

  Future<List<String>> _getFolders() async {
    final response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<String>;
    } else {
      throw Exception();
    }
  }
}