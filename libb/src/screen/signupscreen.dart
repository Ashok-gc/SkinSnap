
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/users.dart';
import '../Utilities/colors.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  DateTime selectedDate = DateTime.now();
  DateTime? picked;
  String dropDownValue = 'Select a Gender';
  var genderList = [
    'Select a Gender',
    'Male',
    'Female',
  ];

  Future<void> _selectDate(BuildContext context) async {
    picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1975, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked!;
        debugPrint(selectedDate.toLocal().toString().split(' ')[0]);
      });
    }
  }

  final _auth = FirebaseAuth.instance;
  final formkey = GlobalKey<FormState>();
  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var email = TextEditingController();
  var phoneNo = TextEditingController();
  var password = TextEditingController();
  bool showpassword = true;

  void signUp(String email, String password) {
    setState(() {
      _auth
          .createUserWithEmailAndPassword(
              email: email.toLowerCase(), password: password)
          .then((value) => addUserToFirebase())
          .catchError((error) {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              dismissDirection: DismissDirection.horizontal,
              content: Text(
                error.message.toString(),
                style: const TextStyle(
                    color: whiteColor, fontSize: 16, fontFamily: "Poppins"),
              ),
            ),
          );
        });
      });
    });
  }

  addUserToFirebase() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser!;

    Users users = Users(
      firstName: firstName.text,
      lastName: lastName.text,
      email: email.text.toLowerCase(),
      password: password.text,
      phoneNo: phoneNo.text,
      profileUrl: "",
      birthDate: selectedDate.toLocal().toString().split(' ')[0],
      gender: dropDownValue,
    );

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(users.toJson());
    setState(() {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          dismissDirection: DismissDirection.horizontal,
          backgroundColor: Colors.green,
          content: Text(
            "Account Created Successfully",
            style: TextStyle(
                color: whiteColor, fontSize: 16, fontFamily: "Poppins"),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formkey,
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Text(
                      "Create New Account",
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Enter your credentials to continue",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.5,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: firstName,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter first name";
                        }
                        return null;
                      },
                      // ignore: prefer_const_constructors
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        hintText: "Enter your first name",
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
                      controller: lastName,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter last name";
                        }
                        return null;
                      },
                      // ignore: prefer_const_constructors
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        hintText: "Enter your last name",
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
                    picked == null
                        ? InkWell(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(),
                              ),
                              child: const ListTile(
                                leading: Icon(Icons.calendar_month),
                                title: Text("Date of Birth",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 16,
                                    )),
                                trailing: Icon(Icons.arrow_drop_down),
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(),
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.calendar_month),
                                title: Text(
                                    "${selectedDate.toLocal()}".split(' ')[0],
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    )),
                                trailing: const Icon(Icons.arrow_drop_down),
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 15,
                    ),
                    DropdownButtonFormField(
                        validator: (String? value) {
                          if (value == genderList[0]) {
                            return "Please! Select a Gender";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Gender",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        borderRadius: BorderRadius.circular(30),
                        value: dropDownValue,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: genderList.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            dropDownValue = value!;
                          });
                        }),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: phoneNo,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your phone no";
                        }
                        return null;
                      },
                      // ignore: prefer_const_constructors
                      decoration: InputDecoration(
                        prefixText: "+977 ",
                        labelText: 'Phone Number',
                        hintText: "Enter your phone no",

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
                    MaterialButton(
                      color: primaryColor,
                      height: 50,
                      minWidth: double.maxFinite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          signUp(email.text, password.text);
                        }
                      },
                      child: const Text(
                        "Sign Up",
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
                                builder: (context) => LoginScreen()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          // ignore: prefer_const_constructors
                          Text(
                            "Already have an account? ",
                            style:
                                // ignore: prefer_const_constructors
                                TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          // ignore: prefer_const_constructors
                          SizedBox(
                            width: 5,
                          ),
                          // ignore: prefer_const_constructors
                          Text(
                            "Sign In",
                            style:
                                // ignore: prefer_const_constructors
                                TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
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
    );
  }
}
