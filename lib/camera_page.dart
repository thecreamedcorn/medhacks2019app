import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:medhacks2019app/folder_select.dart';
import 'package:medhacks2019app/trial_select.dart';

import 'globals.dart';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'package:http/http.dart' as http;

// A screen that allows users to take a picture using a given camera.
class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String study;

  const CameraPage({
    Key key,
    this.study,
    @required this.cameras,
  }) : super(key: key);

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  int _cameraNumber;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.

    _cameraNumber = 0;

    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.cameras[_cameraNumber],
      // Define the resolution to use.
      ResolutionPreset.high,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        PositionedTapDetector(
          onDoubleTap: (_) => setState(() {
            _cameraNumber = (_cameraNumber + 1) % widget.cameras.length;
            _controller = CameraController(
              widget.cameras[_cameraNumber],
              ResolutionPreset.high,
            );
            _initializeControllerFuture = _controller.initialize();
          }),
          child: Container (
            color: Colors.black,
            child: Center(
              child: FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If the Future is complete, display the preview.
                    return AspectRatio(
                      aspectRatio: 1,
                      child: ClipRect(
                        child: Transform.scale(
                          scale: 1 / _controller.value.aspectRatio,
                          child: Center(
                            child: AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: CameraPreview(_controller),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    // Otherwise, display a loading indicator.
                    return Center(child: CircularProgressIndicator());
                  }
                },
              )
            )
          )
        ),
        Positioned(
          bottom: 30,
          right: 30,
          child: FloatingActionButton(
            child: Icon(Icons.camera_alt),
            // Provide an onPressed callback.
            onPressed: () async {
              // Take the Picture in a try / catch block. If anything goes wrong,
              // catch the error.
              try {
                // Ensure that the camera is initialized.
                await _initializeControllerFuture;

                // Construct the path where the image should be saved using the
                // pattern package.
                final path = join(
                  // Store the picture in the temp directory.
                  // Find the temp directory using the `path_provider` plugin.
                  (await getTemporaryDirectory()).path,
                  '${DateTime.now()}.png',
                );

                // Attempt to take a picture and log where it's been saved.
                await _controller.takePicture(path);

                // If the picture was taken, display it on a new screen.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DisplayPictureScreen(imagePath: path),
                  ),
                );
              } catch (e) {
                // If an error occurs, log the error to the console.
                print(e);
              }
            },
          ),
        )
      ]
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final String study;

  const DisplayPictureScreen({
    Key key,
    this.study,
    @required this.imagePath
  }) : super(key: key);

  @override
  _DisplayPictureScreen createState() {
    return _DisplayPictureScreen();
  }
}

class _DisplayPictureScreen extends State<DisplayPictureScreen> {
  Future<Map<String, dynamic>> _verifyingImageFuture;

  @override
  void initState() {
    super.initState();

    _verifyingImageFuture = _verifyImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Review Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: ListView (
        shrinkWrap: true,
        children: <Widget>[
          Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    alignment: FractionalOffset.center,
                    image: Image.file(File(widget.imagePath)).image,
                  )
                ),
              ),
            )
          ),
          FutureBuilder(
            future: _verifyingImageFuture,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Column(
                    children: <Widget>[
                      CircularProgressIndicator(),
                      Text("Sending Image")
                    ],
                  );
                default:
                  return Container(
                    padding: EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: double.infinity,
                            child: Card(
                              elevation: 2,
                              child: Container(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Results",
                                          style: TextStyle(
                                            fontSize: 20
                                          ),
                                          textAlign: TextAlign.left
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(snapshot.hasError ? "Success" : "Failure",
                                        textAlign: TextAlign.left
                                      ),
                                    )
                                  ]
                                )
                              )
                            )
                          ),
                          ButtonTheme (
                            minWidth: double.infinity,
                            child: MaterialButton(
                              onPressed: () async {
                                var json = new Map<String, dynamic>();
                                json['folder'] = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FolderSelect()
                                  )
                                );
                                if (json['folder'] == null) return;

                                if (widget.study == null) {
                                  json['study'] = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TrialSelect()
                                    )
                                  );
                                } else {
                                  json['study'] = widget.study;
                                }

                                //TODO push http request

                                Navigator.pop(context, null);
                              },
                              color: Colors.lightBlue,
                              child: Text("Choose Folder and Submit")
                            )
                          )
                        ]
                      )
                    )
                  );
              }
            }
          )
        ]
      )
    );
  }

  Future<Map<String, dynamic>> _verifyImage() async {
    final response = await http.get(apiUrl + "/piture/verify");
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Could not upload image to server');
    }
  }
}