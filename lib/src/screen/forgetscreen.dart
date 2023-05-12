import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skinsnap/src/screen/login_screen.dart';
import '../Utilities/colors.dart';

class ForgetScreen extends StatefulWidget {
  const ForgetScreen({super.key});

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  var email = TextEditingController();
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formkey,
                // ignore: prefer_const_literals_to_create_immutables
                child: Column(
                  children: [
                    const Text(
                      "Forget Password",
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Please enter your valid email",
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 16.5,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const SizedBox(
                      height: 15,
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
                    MaterialButton(
                      color: primaryColor,
                      height: 50,
                      minWidth: double.maxFinite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onPressed: () async {
                        if (formkey.currentState!.validate()) {
                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(email: email.text);
                          setState(() {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                                (route) => false);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                    "Check your email inbox, Email is sent to: ${email.text}.")));
                          });
                        }
                      },
                      child: const Text(
                        "Reset Password",
                        style: TextStyle(color: whiteColor, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
