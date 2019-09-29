import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:medhacks2019app/view_image.dart';
import 'package:path/path.dart' show join;
import 'package:medhacks2019app/globals.dart';
import 'package:path_provider/path_provider.dart';
import 'package:transparent_image/transparent_image.dart';

class FolderImages extends StatefulWidget {
  final String folder;

  const FolderImages({
    Key key,
    @required this.folder
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FolderImagesState();
  }

}

class PathAndDate {
  String path;
  DateTime date;

  PathAndDate({
    this.path,
    this.date,
  });
}

class _FolderImagesState extends State<FolderImages> {
  Future<List<PathAndDate>> _pathsAndDatesFuture;

  @override
  void initState() {
    super.initState();

    _pathsAndDatesFuture = _getImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(widget.folder)
      ),
      body: FutureBuilder(
        future: _pathsAndDatesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<PathAndDate> list = snapshot.data;
            return Container(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                //imageCount: list.length,
                itemBuilder: (context, index) {
                  PathAndDate imageData = list[index];
                  ImageProvider image = new AssetImage(imageData.path);
                  return Container(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewImage(date: imageData.date.toString(), path: imageData.path),
                          ),
                        );
                      },
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          FadeInImage(
                            image: image,
                            placeholder: MemoryImage(kTransparentImage),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          Container(
                            color: Colors.black.withOpacity(0.7),
                            height: 30,
                            width: double.infinity,
                            child: Center(
                              child: Text(imageData.date.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Regular'
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    )
                  );
                }
              )
            );
          } else {
            return Container();
          }
        },
      )
    );
  }

  Future<List<PathAndDate>> _getImages() async {
    final String url = apiUrl + "/photosFromFolder?name=" + widget.folder;
    final request = await http.post(url);
    if (request.statusCode == 200) {
      var pathsAndDates = new List<PathAndDate>();
      for (var imageAndDate in (json.decode(request.body) as List<Map<String, dynamic>>)) {
        final path = join((await getTemporaryDirectory()).path, '${DateTime.now()}.png');
        File(path).writeAsBytes(base64.decode(imageAndDate['photo']));
        final date = DateTime.parse(imageAndDate['date']);
        pathsAndDates.add(PathAndDate(path: path, date: date));
      }
      return pathsAndDates;
    } else {
      throw Exception();
    }
  }
}