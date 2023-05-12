import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skinsnap/model/users.dart';
import 'package:skinsnap/src/Utilities/constant.dart';
import 'package:skinsnap/src/screen/login_screen.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _loading = false;
  bool _obscureText = true;
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? id;

  Future changePassword() async {
    setState(() {
      _loading = true;
    });
    User? user = FirebaseAuth.instance.currentUser;
    id = user?.uid;

    final userCredential = EmailAuthProvider.credential(
        email: UserData.users.email!, password: UserData.users.password!);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .update({'password': _newPassword.text}).then((value) async {
      setState(() {
        UserData.users.password = _newPassword.text;
      });
      await user!.reauthenticateWithCredential(userCredential).then((_) async {
        await user.updatePassword(_newPassword.text).then((value) {
          setState(() {
            _loading = false;
          });
          debugPrint("UserCredential Updated...");
        });
      });
    }).catchError((err) {
      debugPrint(err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white54,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: _loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: Colors.indigo,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Processing...",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Reset Password",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        controller: _currentPassword,
                        obscureText: _obscureText,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter Current Password";
                          } else if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black,
                            ),
                          ),
                          labelText: "Current Password",
                          labelStyle: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black38),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black38),
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black38),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        controller: _newPassword,
                        obscureText: _obscureText1,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter New Password";
                          } else if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          } else if (value != _confirmPassword.text) {
                            return "Password does not match";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText1 = !_obscureText1;
                              });
                            },
                            icon: Icon(
                              _obscureText1
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black,
                            ),
                          ),
                          labelText: "New Password",
                          labelStyle: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black38),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black38),
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black38),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter Confirm Password";
                          } else if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          } else if (value != _newPassword.text) {
                            return "Password does not match";
                          }
                          return null;
                        },
                        controller: _confirmPassword,
                        obscureText: _obscureText2,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText2 = !_obscureText2;
                              });
                            },
                            icon: Icon(
                              _obscureText2
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black,
                            ),
                          ),
                          labelText: "Confirm Password",
                          labelStyle: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black38),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black38),
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black38),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            if (UserData.users.password !=
                                _currentPassword.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    "Current Password is incorrect",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                              return;
                            } else {
                              setState(() {
                                changePassword().then((_) {
                                  FirebaseAuth.instance.signOut();
                                  UserData.users = Users();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()),
                                      (route) => false);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text(
                                        "Password Changed Successfully",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  );
                                });
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Change Password",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
