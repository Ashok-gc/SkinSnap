import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../model/users.dart';
import '../../Utilities/constant.dart';
import '../login_screen.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool _loading = false;
  final picker = ImagePicker();
  File? _image;
  String? id;
  String? tempProfileUrl;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstName =
      TextEditingController(text: UserData.users.firstName);
  final TextEditingController _lastName =
      TextEditingController(text: UserData.users.lastName);
  final TextEditingController _email =
      TextEditingController(text: UserData.users.email);
  final TextEditingController _phoneNo =
      TextEditingController(text: UserData.users.phoneNo);
  Future _browseImage(ImageSource imageSource) async {
    try {
      // Source is either Gallary or Camera
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image != null) {
        setState(() {
          _image = File(image.path);
        });
      } else {
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future updateProfile() async {
    setState(() {
      _loading = true;
    });
    User? user = FirebaseAuth.instance.currentUser;
    id = user?.uid;

    debugPrint(id);
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    if (UserData.users.profileUrl == "" || UserData.users.profileUrl != "") {
      Reference ref1 = firebaseStorage.ref('profilePicture/${user!.uid}');
      if (_image != null) {
        await ref1.putFile(File(_image!.path.toString())).catchError((e) {
          return e.toString();
        });
        await ref1.getDownloadURL().then((value) {
          setState(() {
            tempProfileUrl = value.toString();
            debugPrint(tempProfileUrl);
          });
        });
      }
    }
    await FirebaseFirestore.instance.collection('users').doc(user?.uid).update({
      'profileUrl': tempProfileUrl ?? UserData.users.profileUrl,
      'phoneNo': _phoneNo.text,
      'firstName': _firstName.text,
      'lastName': _lastName.text,
      'email': _email.text,
    }).then((value) async {
      setState(() {
        UserData.users.phoneNo = _phoneNo.text;
        UserData.users.profileUrl = tempProfileUrl ?? UserData.users.profileUrl;
        UserData.users.firstName = _firstName.text;
        UserData.users.lastName = _lastName.text;
        UserData.users.email = _email.text;
        _loading = false;
      });
    }).catchError((err) {
      debugPrint(err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white24,
        elevation: 0,
        title: Text(
          "Edit Profile",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      body: _loading
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(
                  color: Colors.indigo,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Updating Profile.....",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ))
          : SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white24,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 25, 20, 18),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                isDismissible: true,
                                enableDrag: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => Container(
                                      height: 100,
                                      decoration: const BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(50))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            SizedBox(
                                              height: 50,
                                              child: ElevatedButton.icon(
                                                onPressed: () {
                                                  _browseImage(
                                                      ImageSource.camera);
                                                },
                                                style: const ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStatePropertyAll(
                                                            Colors.indigo)),
                                                icon: const Icon(Icons.camera),
                                                label: const Text("Camera"),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 50,
                                              child: ElevatedButton.icon(
                                                onPressed: () {
                                                  _browseImage(
                                                      ImageSource.gallery);
                                                },
                                                style: const ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStatePropertyAll(
                                                            Colors.indigo)),
                                                icon: const Icon(Icons.photo),
                                                label: const Text("Gallery"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ));
                          },
                          child: Stack(
                            children: [
                              if (_image != null) ...{
                                CircleAvatar(
                                  radius: 80,
                                  backgroundImage: Image.file(_image!).image,
                                ),
                              } else if (_image == null &&
                                  UserData.users.profileUrl == "") ...{
                                CircleAvatar(
                                  radius: 80,
                                  backgroundImage:
                                      Image.asset("assets/logo/profile.png")
                                          .image,
                                ),
                              } else ...{
                                CircleAvatar(
                                  radius: 80,
                                  backgroundImage:
                                      Image.network(UserData.users.profileUrl!)
                                          .image,
                                )
                              },
                              Positioned(
                                bottom: 5,
                                right: 5,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.indigo,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50),
                                    ),
                                  ),
                                  width: 40,
                                  height: 40,
                                  child: const Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _firstName,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your first name";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.person_outlined,
                              color: Colors.black,
                            ),
                            hintText: "Enter your first name",
                            labelText: "First Name",
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                            labelStyle: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 3),
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _lastName,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your last name";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.person_outlined,
                              color: Colors.black,
                            ),
                            hintText: "Enter your first name",
                            labelText: "Last Name",
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                            labelStyle: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 3),
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _email,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your email address";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: Colors.black,
                            ),
                            hintText: "Enter your email address",
                            labelText: "Email Address",
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                            labelStyle: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 3),
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _phoneNo,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your phone no";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.phone_android_outlined,
                              color: Colors.black,
                            ),
                            hintText: "Enter your phone no",
                            labelText: "Phone No",
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                            labelStyle: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 3),
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          height: 50,
                          width: 250,
                          child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    debugPrint("Hello");
                                    updateProfile().then((_) {
                                      setState(() {
                                        FirebaseAuth.instance.signOut();
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen()),
                                            (route) => false);
                                        UserData.users = Users();
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              duration: Duration(seconds: 2),
                                              backgroundColor: Colors.green,
                                              content: Text(
                                                  "Profile Updated Successful")));
                                    });
                                  });
                                }
                              },
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.indigo)),
                              child: Text(
                                "Update Profile",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
