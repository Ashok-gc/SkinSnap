import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../model/users.dart';
import '../../Utilities/constant.dart';
import '../login_screen.dart';
import 'change_password.dart';
import 'edit_profile.dart';
import 'faq_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool loading = false;
  String? id;
  String? tempProfileUrl;
  final _phoneNo = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final formKey = GlobalKey<FormState>();
  File? _image;
  signOut() async {
    await FirebaseAuth.instance.signOut().then((value) {
      setState(() {
        setState(() {
          loading = true;
        });
      });
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 2),
          content: Text("Sign Out Successfully"),
          backgroundColor: Colors.green,
        ));
      });
    });
    UserData.users = Users();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white54,
        elevation: 0,
        centerTitle: true,
        title: Text("Profile",
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.w600,
            )),
      ),
      body: SingleChildScrollView(
        child: loading != false
            ? SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(
                      color: Colors.indigo,
                    ),
                    Text("Hang On! Signing Out.....")
                  ],
                ),
              )
            : Container(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                color: Colors.white54,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: UserData.users.profileUrl == ""
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: const Image(
                                image: AssetImage('assets/logo/profile.png'),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image(
                                image: NetworkImage(UserData.users.profileUrl!),
                              ),
                            ),
                    ),
                    const SizedBox(height: 10),
                    UserData.users.firstName == null
                        ? Text("Full Name",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ))
                        : Text(
                            "${UserData.users.firstName} ${UserData.users.lastName}",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            )),
                    UserData.users.email == null
                        ? Text("email@gmail.com",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ))
                        : Text("${UserData.users.email}",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            )),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const EditProfile()));
                        },
                        child: Text("Edit Profile",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Divider(),
                    const SizedBox(height: 10),
                    ProfileTile(
                      title: "Change Password",
                      icon: Icons.lock,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ChangePassword()));
                      },
                    ),
                    ProfileTile(
                      title: "FAQ",
                      icon: Icons.question_answer,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FaqScreen()));
                      },
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    ProfileTile(
                      title: "Logout",
                      icon: Icons.logout,
                      color: Colors.red,
                      endIcon: false,
                      onTap: signOut,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class ProfileTile extends StatelessWidget {
  String? title;
  VoidCallback? onTap;
  IconData? icon;
  bool endIcon;
  Color color;
  ProfileTile({
    super.key,
    this.title,
    this.onTap,
    this.icon,
    this.endIcon = true,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.indigo.withOpacity(0.6),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
      title: Text(title!,
          style: GoogleFonts.poppins(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          )),
      trailing: endIcon
          ? Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
            )
          : null,
    );
  }
}
