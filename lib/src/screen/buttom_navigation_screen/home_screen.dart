import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skinsnap/model/users.dart';
import 'package:skinsnap/src/Utilities/constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  Users? users = Users();
  final CollectionReference _users =
      FirebaseFirestore.instance.collection("users");

  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _users.doc(_auth.currentUser!.uid).get().then((value) {
        setState(() {
          users = Users.fromMap(value.data() as Map<String, dynamic>);
          UserData.users = Users.fromMap(value.data() as Map<String, dynamic>);
          loading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return !loading
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white24,
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  UserData.users.profileUrl == ""
                      ? Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              image: const DecorationImage(
                                  image:
                                      AssetImage("assets/logo/profile.png"))),
                        )
                      : Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      UserData.users.profileUrl!))),
                        ),
                  // CircleAvatar(
                  //   radius: 20,
                  //   backgroundImage: widget.users?.profileUrl! == "" ||
                  //           UserData.users.profileUrl == ""
                  //       ? Image.asset(
                  //           "assets/logo/profile.png",
                  //           fit: BoxFit.cover,
                  //         ).image
                  //       : Image.network(UserData.users.profileUrl!).image,
                  // ),
                ],
              ),
            ),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white24,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 25, 20, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserData.users.firstName != null
                        ? Text("Welcome, ${UserData.users.firstName}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontFamily: "Poppins",
                            ))
                        : const Text("Welcome,",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontFamily: "Poppins",
                            )),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                        decoration: BoxDecoration(border: Border.all()),
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset("assets/images/home.png")),
                    const SizedBox(
                      height: 10,
                    ),
                    const Center(
                      child: Text(
                        "Diagnosis",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.indigo,
              ),
            ),
          );
  }
}
