import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:skinsnap/model/users.dart';
import 'package:skinsnap/src/Utilities/constant.dart';
import 'package:skinsnap/src/screen/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
  final TextEditingController _oldPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
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
    User? user = FirebaseAuth.instance.currentUser;
    id = user?.uid;

    debugPrint(id);
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    if (UserData.users.profileUrl == "") {
      Reference ref1 = firebaseStorage.ref('profilePicture/${user!.uid}');
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
    final userCredential = EmailAuthProvider.credential(
        email: UserData.users.email!, password: UserData.users.password!);
    await FirebaseFirestore.instance.collection('users').doc(user?.uid).update({
      'profileUrl': tempProfileUrl,
      'phoneNo': _phoneNo.text,
      'password': _newPassword.text
    }).then((value) async {
      setState(() {
        UserData.users.phoneNo = _phoneNo.text;
        UserData.users.password = _newPassword.text;
        UserData.users.profileUrl = tempProfileUrl;
      });
      await user!.reauthenticateWithCredential(userCredential).then((_) async {
        await user.updatePassword(_newPassword.text).then((value) {
          debugPrint("UserCredential Updated...");
        });
      });
    }).catchError((err) {
      debugPrint(err.toString());
    });
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 2),
        content: Text("Sign Out Successfully"),
      ));
    });
    UserData.users = Users();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        InkWell(
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
                          child: Stack(children: [
                            if (_image != null) ...{
                              CircleAvatar(
                                radius: 35,
                                backgroundImage: Image.file(_image!).image,
                              ),
                            } else if (_image == null &&
                                UserData.users.profileUrl == "") ...{
                              CircleAvatar(
                                radius: 35,
                                backgroundImage:
                                    Image.asset("assets/logo/man.png").image,
                              ),
                            } else ...{
                              CircleAvatar(
                                radius: 35,
                                backgroundImage:
                                    Image.network(UserData.users.profileUrl!)
                                        .image,
                              )
                            },
                            const Positioned(
                                bottom: 0,
                                right: 0,
                                child: Icon(
                                  Icons.edit,
                                  size: 30,
                                  color: Colors.indigo,
                                ))
                          ]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${UserData.users.firstName}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Personal",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Full Name:",
                            style: TextStyle(
                              fontSize: 15,
                            )),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                                hintText:
                                    "${UserData.users.firstName} ${UserData.users.lastName}",
                                border: const OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Email:",
                            style: TextStyle(
                              fontSize: 15,
                            )),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: TextFormField(
                            enabled: false,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                hintText: "${UserData.users.email}",
                                border: const OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Phone No:",
                            style: TextStyle(
                              fontSize: 15,
                            )),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: TextFormField(
                            controller: _phoneNo,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: UserData.users.phoneNo == ""
                                    ? "Not Available"
                                    : "${UserData.users.phoneNo}",
                                border: const OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Change Password",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Old Password:",
                            style: TextStyle(
                              fontSize: 15,
                            )),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.8,
                          child: TextFormField(
                            controller: _oldPassword,
                            obscureText: true,
                            decoration: const InputDecoration(
                                hintText: "Old Password",
                                border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("New Password:",
                            style: TextStyle(
                              fontSize: 15,
                            )),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.8,
                          child: TextFormField(
                            controller: _newPassword,
                            obscureText: true,
                            onSaved: (newValue) {
                              _newPassword.text = newValue!;
                            },
                            decoration: const InputDecoration(
                                hintText: "New Password",
                                border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Confirm Password:",
                            style: TextStyle(
                              fontSize: 15,
                            )),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.8,
                          child: TextFormField(
                            controller: _confirmPassword,
                            obscureText: true,
                            onSaved: (newValue) {
                              _confirmPassword.text = newValue!;
                            },
                            decoration: const InputDecoration(
                                hintText: "Confirm Password",
                                border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text("Settings",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        )),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Terms and Conditions",
                            style: TextStyle(
                              fontSize: 12,
                            )),
                        InkWell(
                          child: Icon(Icons.arrow_forward_ios,
                              size: 18, color: Colors.black),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Privacy policy",
                            style: TextStyle(
                              fontSize: 12,
                            )),
                        InkWell(
                          child: Icon(Icons.arrow_forward_ios,
                              size: 18, color: Colors.black),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: SizedBox(
                            width: 250,
                            height: 35,
                            child: MaterialButton(
                              color: Colors.indigo,
                              onPressed: () {
                                debugPrint(UserData.users.password);
                                if (_newPassword.text ==
                                        _confirmPassword.text &&
                                    _oldPassword.text ==
                                        UserData.users.password) {
                                  setState(() {
                                    debugPrint("Hello");
                                    updateProfile().then((_) {
                                      FirebaseAuth.instance.signOut();
                                      UserData.users = Users();
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen()),
                                          (route) => false);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              duration: Duration(seconds: 2),
                                              backgroundColor: Colors.green,
                                              content: Text(
                                                  "Profile Updated Successful")));
                                    });
                                  });
                                } else {
                                  MotionToast.error(
                                      description: const Text(
                                    "Please! Check your password",
                                    style: TextStyle(
                                        fontSize: 15,
                                        backgroundColor: Colors.white),
                                  ));
                                }
                              },
                              child: const Text(
                                "Save Profile",
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: SizedBox(
                            width: 250,
                            height: 35,
                            child: MaterialButton(
                              color: Colors.redAccent,
                              onPressed: () {
                                signOut();
                              },
                              child: const Text(
                                "LOG OUT",
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
