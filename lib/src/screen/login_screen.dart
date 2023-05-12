import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skinsnap/model/users.dart';
import 'package:skinsnap/src/screen/forgetscreen.dart';
import 'package:skinsnap/src/screen/navigationBar.dart';
import 'package:skinsnap/src/screen/signupscreen.dart';
import '../Utilities/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final CollectionReference _users =
      FirebaseFirestore.instance.collection("users");
  var email = TextEditingController();
  var password = TextEditingController();
  final formkey = GlobalKey<FormState>();
  Users? users;
  bool showpassword = true;
  void signIn(String email, String password) {
    if (formkey.currentState!.validate()) {
      _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) {
        _users.doc(_auth.currentUser!.uid).get().then((value) {
          users = Users.fromMap(value.data() as Map<String, dynamic>);
        });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                // ignore: prefer_const_constructors
                builder: (context) => Navigation(
                      users: users,
                    )),
            (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Login Successfully",
              style: TextStyle(
                  color: whiteColor, fontSize: 18, fontFamily: "Poppins"),
            ),
          ),
        );
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "Login Unsuccessfully",
              style: TextStyle(
                  color: whiteColor, fontSize: 18, fontFamily: "Poppins"),
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: formkey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 3.5,
                        child: Image.asset(
                          "assets/images/login.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "Welcome",
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Sign in to continue",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.5,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: email,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your email";
                          }
                          return null;
                        },
                        // ignore: prefer_const_constructors
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: "Enter your email",
                          // ignore: prefer_const_constructors
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorBorder: OutlineInputBorder(
                            // ignore: prefer_const_constructors
                            borderSide: BorderSide(color: redColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            // ignore: prefer_const_constructors
                            borderSide: BorderSide(color: redColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: password,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your password";
                          }
                          return null;
                        },
                        obscureText: showpassword,
                        // ignore: prefer_const_constructors
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: "Enter your password",
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(
                                () {
                                  showpassword = !showpassword;
                                },
                              );
                            },
                            // ignore: prefer_const_constructors
                            icon: Icon(showpassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          // ignore: prefer_const_constructors
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorBorder: OutlineInputBorder(
                            // ignore: prefer_const_constructors
                            borderSide: BorderSide(color: redColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            // ignore: prefer_const_constructors
                            borderSide: BorderSide(color: redColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          // ignore: prefer_const_constructors
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      // ignore: prefer_const_constructors
                                      builder: (context) => ForgetScreen()));
                            },
                            // ignore: prefer_const_constructors
                            child: Text(
                              "Forget password? ",
                              // ignore: prefer_const_constructors
                              style: TextStyle(
                                  color: Colors.lightBlueAccent,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      // ignore: prefer_const_constructors
                      SizedBox(
                        height: 15,
                      ),
                      MaterialButton(
                        color: primaryColor,
                        height: 50,
                        minWidth: double.maxFinite,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onPressed: () {
                          signIn(email.text, password.text);
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(color: whiteColor, fontSize: 16),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  // ignore: prefer_const_constructors
                                  builder: (context) => SignUpScreen()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            // ignore: prefer_const_constructors
                            Text(
                              "Don't have an account?",
                              style:
                                  // ignore: prefer_const_constructors
                                  TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                            ),
                            // ignore: prefer_const_constructors
                            SizedBox(
                              width: 5,
                            ),
                            // ignore: prefer_const_constructors
                            Text(
                              "Sign up",
                              style:
                                  // ignore: prefer_const_constructors
                                  TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
