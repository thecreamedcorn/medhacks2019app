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
      body: FutureBuilder(
        future: _foldersFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              //var list = snapshot.data;
              var list = <String> [
                "one",
                "two",
                "three",
                "four",
              ];
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 2,
                      child: InkWell(
                        onTap: () => Navigator.pop(context, list[index]),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.folder),
                                Text(list[index])
                              ]
                            )
                          )
                        )
                      )
                    )
                  );
                }
              );
          }
        },
      )
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