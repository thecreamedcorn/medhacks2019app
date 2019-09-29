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
class CameraWidget extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String study;

  const CameraWidget({
    Key key,
    this.study,
    @required this.cameras,
  }) : super(key: key);

  @override
  CameraWidgetState createState() => CameraWidgetState();
}

class CameraWidgetState extends State<CameraWidget> {
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
          bottom: 15,
          right: 15,
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

                print("THE PATH TO THE PICTURE" + path);

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
  Future<Map> _verifyingImageFuture;

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
              if (snapshot.hasData) {
                Map data = snapshot.data;
                final bool valid = data['valid'];
                final classification = valid ? data['photo']['photo']['classification'] : null;
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
                                children: valid
                                  ? <Widget>[
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
                                    _makeClassification('Actinic Keratoses', classification['actinic_keratoses']),
                                    SizedBox(height: 10),
                                    _makeClassification('Basal Cell Carcinoma', classification['basal_cell_carcinoma']),
                                    SizedBox(height: 10),
                                    _makeClassification('Benign Keratosis', classification['benign_keratosis']),
                                    SizedBox(height: 10),
                                    _makeClassification('Dermatofibroma', classification['dermatofibroma']),
                                    SizedBox(height: 10),
                                    _makeClassification('Malignant Melanoma', classification['malignant_melanoma']),
                                    SizedBox(height: 10),
                                    _makeClassification('Melanocytic Nevi', classification['melanocytic_nevi']),
                                    SizedBox(height: 10),
                                    _makeClassification('Vascular Lesions', classification['vascular_lesions']),
                                  ]
                                : <Widget> [
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
                                    child: Text('Failure: ' + data['reason'],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.red
                                        ),
                                    ),
                                  )
                                ]
                              )
                            )
                          )
                        ),
                        valid
                        ? ButtonTheme (
                            minWidth: double.infinity,
                            child: MaterialButton(
                              onPressed: () async {
                                var folder;
                                var trial;
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FolderSelect(
                                      mainPage: false,
                                      onSelected: (selectedFolder) {
                                        folder = selectedFolder;
                                        Navigator.pop(context);
                                      },
                                    )
                                  )
                                );
                                if (folder == null) return;

                                if (widget.study == null) {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TrialSelect(
                                        mainPage: false,
                                        onSelected: (selectedTrial) {
                                          trial = selectedTrial;
                                          Navigator.pop(context);
                                        },
                                      )
                                    )
                                  );
                                  if (trial == null) return;
                                } else {
                                  trial = widget.study;
                                }

                                final url = apiUrl + "/submitPhoto";
                                final Map<String, String> headers = {"Content-type": "application/json"};
                                data.remove('valid');
                                data['trialId'] = trial;
                                data['photo']['folder'] = folder;
                                await http.post(url, headers: headers, body: json.encode(data));

                                Navigator.pop(context, null);
                              },
                              color: Colors.lightBlue,
                              child: Text("Choose Folder and Submit")
                            )
                          )
                        : ButtonTheme (
                            minWidth: double.infinity,
                            child: MaterialButton(
                              color: Colors.red,
                              child: Text("Retake Image"),
                              onPressed: () => Navigator.pop(context, null)
                            )
                        )
                      ]
                    )
                  )
                );
              } else {
                return Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 40),
                        CircularProgressIndicator(),
                        SizedBox(height: 15),
                        Text("Sending Image")
                      ],
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

  Future<Map> _verifyImage() async {
    final b64Image = base64.encode(await (new File(widget.imagePath)).readAsBytes());
    final url = apiUrl + "/analyzePhoto/";
    final Map<String, String> headers = {"Content-type": "application/json"};
    final Map<String, dynamic> body = {
      "photo" : b64Image
    };
    final response = await http.post(url, headers: headers, body: json.encode(body));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Could not upload image to server');
    }
  }

  Widget _makeClassification(String name, String percent) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(name + ": " + percent + "%",
          textAlign: TextAlign.left
      ),
    );
  }
}