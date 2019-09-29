import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medhacks2019app/globals.dart';
import 'package:http/http.dart' as http;
import 'package:medhacks2019app/kira_appbar.dart';

class FolderSelect extends StatefulWidget {
  final ValueChanged<String> onSelected;
  final bool mainPage;

  const FolderSelect({
    Key key,
    @required this.mainPage,
    @required this.onSelected
  }) : super(key: key);

  @override
  _FolderSelectState createState() {
    return _FolderSelectState();
  }

}

class _FolderSelectState extends State<FolderSelect> {
  Future<List<String>> _foldersFuture;
  List<String> _folders;
  TextEditingController _newFolderTextFieldController = TextEditingController();

  String newFolderName;

  @override
  void initState() {
    super.initState();

    _foldersFuture = _getFolders();
    _foldersFuture.then((list) => setState(() => _folders = list));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.mainPage
        ? kiraAppBar(context)
        : AppBar(
          title: Text('Select Trial'),
        ),
      body: FutureBuilder(
        future: _foldersFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: _folders.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 2,
                    child: InkWell(
                      onTap: () => widget.onSelected(_folders[index]),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.folder),
                              SizedBox(width: 20),
                              Text(_folders[index])
                            ]
                          )
                        )
                      )
                    )
                  )
                );
              }
            );
          } else {
            return  Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn2",
        child: Icon(Icons.add),
        onPressed: () async {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('New Folder'),
                content: TextField(
                  controller: _newFolderTextFieldController,
                  decoration: InputDecoration(hintText: "folder name"),
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text('CANCEL'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  new FlatButton(
                    child: new Text('OK'),
                    onPressed: () async {
                      final list = await _foldersFuture;
                      var newName = _newFolderTextFieldController.text;
                      if (newName != "" && !list.contains(_newFolderTextFieldController.text)) {
                        final String url = apiUrl + "/addFolder/";
                        final Map<String, String> headers = {"Content-type": "application/json"};
                        final Map<String, dynamic> body = {'name': newName};
                        if ((await http.post(url, headers: headers, body: json.encode(body))).statusCode == 200) {
                          setState(() {
                            _folders.add(newName);
                          });
                        }
                      }
                    },
                  )
                ],
              );
            }
          );
        }
      ),
    );
  }

  Future<List<String>> _getFolders() async {
    final response = await http.post(apiUrl + "/folders/");
    if (response.statusCode == 200) {
      var result = new List<String>();
      for (var obj in json.decode(response.body) as List) {
        result.add(obj['name']);
      }
      return result;
    } else {
      throw Exception();
    }
  }
}