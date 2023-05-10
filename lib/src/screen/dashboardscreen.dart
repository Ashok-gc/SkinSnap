import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';

class SkinDiseasePrediction extends StatefulWidget {
  String? uid;
  SkinDiseasePrediction({super.key, this.uid});

  @override
  _SkinDiseasePredictionState createState() => _SkinDiseasePredictionState();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Skin Disease Prediction",
          style: GoogleFonts.bebasNeue(
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
    );
  }
}

class _SkinDiseasePredictionState extends State<SkinDiseasePrediction> {
  bool _loading = true;
  File? _image;
  List? _output;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
    
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

//Classifying the Image
  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 36,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _output = output;
      _loading = false;
    });
  }

//Loading the model
  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model/model.tflite',
      labels: 'assets/model/labels.txt',
    );
  }

//Take image from photo

  takeImage() async {
    // ignore: deprecated_member_use
    var image = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 100,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
      if (_image == null) {
        print(_image);
      }
    });
    classifyImage(_image!);
  }

  //Pick image from gallery
  pickGalleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white54,
      ),
      body: Container(
        color: Colors.white54,
        child: Column(
          children: [
            Container(
              child: _loading == true
                  ? null //show nothing if no picture selected
                  : Column(
                      children: [
                        const Center(
                          child: Text(
                            "Skin Disease",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          height: 160,
                          width: 160,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.file(
                              _image!,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "PLEASE SELECT SKIN IMAGE FROM GALLERY\n OTHERWISE IT WILL SHOW WRONG PREDICTION",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: takeImage,
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.indigo[700]),
                              ),
                              child: const Icon(Icons.camera_alt_outlined),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.indigo[700]),
                              ),
                              onPressed: pickGalleryImage,
                              child: const Icon(Icons.file_upload_outlined),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 180,
                          height: 40,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.indigo[700]),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("PREDICTION"),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 35,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.indigo[700]),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.refresh),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Disease Name: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 200,
                          height: 35,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.indigo[700]),
                              ),
                              onPressed: () {},
                              child: const Text("TREATMENTS")),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
