import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skinsnap/model/users.dart';
import 'package:skinsnap/src/Utilities/constant.dart';
import 'package:skinsnap/src/screen/treatment_screen.dart';
import 'package:skinsnap/model/disease.dart' as disease;

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  bool loading = false;
  deleteReport(int index) async {
    loading = true;
    await FirebaseFirestore.instance.collection('users').doc(userId).update(
      {
        'history': FieldValue.arrayRemove([UserData.users.history![index]])
      },
    ).then((value) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get()
          .then((value) {
        setState(() {
          UserData.users = Users.fromMap(value.data() as Map<String, dynamic>);
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 2),
            content: Text("Deleted Successfully")));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white54,
        title: Text("History",
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            )),
        elevation: 0,
        centerTitle: true,
      ),
      body: loading
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
                    "Deleting...",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          : SizedBox(
              width: MediaQuery.of(context).size.width,
              // Future builder
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: UserData.users.history!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TreatmentScreen(
                                            diseaseName: UserData.users
                                                .history![index]['disease'],
                                            diseaseDescription: disease
                                                    .diseaseTreatment
                                                    .every((element) =>
                                                        element['name'] !=
                                                        UserData.users
                                                                .history![index]
                                                            ['disease'])
                                                ? []
                                                : disease.diseaseTreatment
                                                    .where((element) {
                                                    return element['name'] ==
                                                        UserData.users
                                                                .history![index]
                                                            ['disease'];
                                                  }).toList()[0]['treatment'],
                                            bulletPoints: disease.symptoms
                                                    .every((element) =>
                                                        element['name'] !=
                                                        UserData.users
                                                                .history![index]
                                                            ['disease'])
                                                ? []
                                                : disease.symptoms
                                                    .where((element) {
                                                    return element['name'] ==
                                                        UserData.users
                                                                .history![index]
                                                            ['disease'];
                                                  }).toList()[0]['symptoms'],
                                          )));
                            },
                            leading: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(UserData
                                      .users.history![index]['imageUrl']!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: RichText(
                              text: TextSpan(
                                text: "Disease: ",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                                children: [
                                  TextSpan(
                                    text: UserData.users.history![index]
                                        ['disease'],
                                    style: GoogleFonts.poppins(
                                      color: Colors.indigo,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            subtitle: Wrap(children: [
                              RichText(
                                text: TextSpan(
                                  text: "Date: ",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: UserData.users.history![index]
                                          ['date'],
                                      style: GoogleFonts.poppins(
                                        color: Colors.indigo,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              RichText(
                                text: TextSpan(
                                  text: "Accuracy: ",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          "${UserData.users.history![index]['accuracy'].toString()} %",
                                      style: GoogleFonts.poppins(
                                        color: Colors.indigo,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                            trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  deleteReport(index);
                                });
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              )),
    );
  }
}
