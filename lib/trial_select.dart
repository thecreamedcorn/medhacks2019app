import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medhacks2019app/globals.dart';
import 'package:http/http.dart' as http;
import 'package:medhacks2019app/kira_appbar.dart';

class TrialSelect extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onSelected;
  final bool mainPage;

  const TrialSelect({
    Key key,
    @required this.mainPage,
    @required this.onSelected
  }) : super(key: key);

  @override
  _TrialSelectState createState() {
    return _TrialSelectState();
  }
}

class _TrialSelectState extends State<TrialSelect> {
  Future<List> _trialsFuture;

  @override
  void initState() {
    super.initState();

    _trialsFuture = _getTrials();
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
          future: _trialsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List list = snapshot.data;

              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 2,
                        child: InkWell(
                          onTap: () => widget.onSelected(list[index] as Map),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(list[index]['name'])
                            )
                          )
                        )
                      )
                  );
                }
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        )
    );
  }

  Future<List> _getTrials() async {
    final String url = apiUrl + "/getTrials/";
    final response = await http.post(url);
    if (response.statusCode == 200) {
      return json.decode(response.body) as List;
    } else {
      throw Exception();
    }
  }
}