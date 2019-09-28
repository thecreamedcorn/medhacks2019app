import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medhacks2019app/globals.dart';
import 'package:http/http.dart' as http;

class TrialSelect extends StatefulWidget {
  @override
  _TrialSelectState createState() {
    return _TrialSelectState();
  }

}

class _TrialSelectState extends State<TrialSelect> {
  Future<List<Map<String, dynamic>>> _trialsFuture;

  @override
  void initState() {
    super.initState();

    _trialsFuture = _getTrials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Select Trial'),
        ),
        body: FutureBuilder(
          future: _trialsFuture,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
              //var list = snapshot.data;
                var list = <Map<String, dynamic>> [
                  { 'uid': 1, 'name': 'study1' },
                  { 'uid': 2, 'name': 'study2' },
                  { 'uid': 3, 'name': 'study3' },
                  { 'uid': 4, 'name': 'study4' }

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
                                child: Text(list[index]['name'])
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

  Future<List<Map<String, dynamic>>> _getTrials() async {
    final response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<Map<String, dynamic>>;
    } else {
      throw Exception();
    }
  }
}