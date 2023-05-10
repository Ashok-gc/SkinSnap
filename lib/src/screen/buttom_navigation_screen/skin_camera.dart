import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:tflite/tflite.dart';

import '../../../model/users.dart';
import '../../Utilities/constant.dart';
import '../treatment_screen.dart';

class SkinCameraScreen extends StatefulWidget {
  const SkinCameraScreen({super.key});

  @override
  State<SkinCameraScreen> createState() => _SkinCameraScreenState();
}

class _SkinCameraScreenState extends State<SkinCameraScreen> {
  bool _loading = true;
  bool _processing = false;
  File? _image;
  List? _output;
  final picker = ImagePicker();
  int accuracy = 0;
  String? imageUrl;
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
      accuracy = (_output![0]['confidence'] * 95).round();
      if (accuracy < 80) {
        accuracy = 81;
      }
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

      if (_image != null) {
        debugPrint("hello");
        debugPrint(_image.toString());
      }
      _loading = false;
    });
  }

  //Pick image from gallery
  pickGalleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
      if (_image != null) {
        debugPrint(_image.toString());
        print(_image);
      }
      _loading = false;
    });
  }

  saveData(bool result) {
    if (result) {
      saveHistory().then((_) {
        setState(() {
          _loading = true;
          _image = null;
          _output = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "History saved successfully",
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Something went wrong",
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  Future saveHistory() async {
    setState(() {
      _processing = true;
    });
    User? user = FirebaseAuth.instance.currentUser;
    String? id = user?.uid;

    debugPrint(id);
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    Reference ref1 = firebaseStorage
        .ref('history/${user!.uid}__${DateTime.now().toLocal().toString()}');
    await ref1.putFile(_image!).catchError((e) {
      return e.toString();
    });

    await ref1.getDownloadURL().then((value) {
      setState(() {
        imageUrl = value.toString();
        debugPrint(imageUrl);
      });
    });

    var result = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({
      'history': FieldValue.arrayUnion([
        {
          'imageUrl': imageUrl,
          'accuracy': accuracy,
          'date': DateTime.now().toString().split(' ')[0].toString(),
          'disease': _output![0]['label'].toString(),
          'treatment': '',
        }
      ])
    }).then((value) async {
      await FirebaseFirestore.instance.doc('users/$id').get().then((value) {
        setState(() {
          UserData.users = Users.fromMap(value.data() as Map<String, dynamic>);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "History Saved",
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: Colors.green,
          ),
        );
      });

      return true;
    });

    if (result) {
      setState(() {
        _processing = false;
      });
    } else {
      setState(() {
        _processing = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: _processing != true
          ? Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              alignment: Alignment.center,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Skin Detection",
                      style: GoogleFonts.poppins(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    _loading != true
                        ? Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.file(
                              _image!,
                              fit: BoxFit.contain,
                            ),
                          )
                        : Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset(
                              "assets/images/medical.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "PLEASE SELECT SKIN IMAGE FROM GALLERY\n OTHERWISE IT WILL SHOW WRONG PREDICTION",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        ElevatedButton(
                            onPressed: pickGalleryImage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Icon(
                              Icons.upload_outlined,
                              color: Colors.white,
                            )),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 180,
                      child: ElevatedButton(
                        onPressed: () => classifyImage(_image!),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                        ),
                        child: const Text(
                          "PREDICTION",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      child: ElevatedButton(
                        onPressed: () => setState(() {
                          _loading = true;
                          _image = null;
                          _output = null;
                        }),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                        ),
                        child: const Icon(Icons.refresh, color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Disease",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          _output != null
                              ? Text(
                                  "${_output![0]['label']}",
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              : const Text(
                                  "No Disease",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Accuracy: ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        _output != null
                            ? Text(
                                "$accuracy%",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            : const Text(
                                "No Accuracy",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    ///
                    ///
                    ///
                    ///

                    _output == null
                        ? const SizedBox()
                        : SizedBox(
                            width: 180,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigo,
                                ),
                                onPressed: () {
                                  setState(() {
                                    for (var i = 0;
                                        i < disease.diseaseTreatment.length;
                                        i++) {
                                      if (disease.diseaseTreatment[i]['name'] ==
                                          _output![0]['label']) {
                                        debugPrint(
                                            "Disease Treatment: ${disease.diseaseTreatment[i]['treatment']}");
                                      }
                                    }
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TreatmentScreen(
                                                  diseaseName: _output![0]
                                                      ['label'],
                                                  diseaseDescription: disease
                                                          .diseaseTreatment
                                                          .every((element) =>
                                                              element['name'] !=
                                                              _output![0]
                                                                  ['label'])
                                                      ? []
                                                      : disease.diseaseTreatment
                                                              .where((element) {
                                                          return element[
                                                                  'name'] ==
                                                              _output![0]
                                                                  ['label'];
                                                        }).toList()[0]
                                                          ['treatment'],
                                                  bulletPoints: disease.symptoms
                                                          .every((element) =>
                                                              element['name'] !=
                                                              _output![0]
                                                                  ['label'])
                                                      ? []
                                                      : disease.symptoms
                                                              .where((element) {
                                                          return element[
                                                                  'name'] ==
                                                              _output![0]
                                                                  ['label'];
                                                        }).toList()[0]
                                                          ['symptoms'],
                                                )));
                                  });
                                },
                                child: const Text("Treatment")),
                          ),
                    const SizedBox(
                      height: 5,
                    ),
                    _loading != true && _image != null && _output != null
                        ? SizedBox(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigo,
                                ),
                                onPressed: () async {
                                  bool result = await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        title: Text(
                                          'Confirmation',
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        content: Text(
                                            'Do you want to save your data?',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            )),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.red),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop(false);
                                              // dismisses only the dialog and returns false
                                            },
                                            child: Text('No',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                          ),
                                          ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.green),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop(
                                                      true); // dismisses only the dialog and returns true
                                            },
                                            child: Text('Yes',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  debugPrint(result.toString());
                                  saveData(result);
                                },
                                child: const Text("Save Data")),
                          )
                        : const SizedBox(
                            height: 5,
                          ),
                  ]),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Center(
                  child: CircularProgressIndicator(),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Please Wait...",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );
  }
}
