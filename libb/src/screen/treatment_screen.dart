import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TreatmentScreen extends StatefulWidget {
  String? diseaseName;
  List<String>? diseaseDescription;
  List<String>? bulletPoints;
  TreatmentScreen(
      {super.key,
      this.diseaseName,
      this.diseaseDescription,
      this.bulletPoints});

  @override
  State<TreatmentScreen> createState() => _TreatmentScreenState();
}

class _TreatmentScreenState extends State<TreatmentScreen> {
  @override
  void initState() {
    super.initState();
    debugPrint(widget.diseaseName!);
    debugPrint(widget.diseaseDescription.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white54,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: widget.diseaseName == null ||
                widget.diseaseName!.isEmpty ||
                widget.diseaseDescription!.isEmpty ||
                widget.bulletPoints!.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Container(
                color: Colors.white54,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "TREATMENTS",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text("What is ${widget.diseaseName}?",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          )),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(widget.diseaseDescription![0],
                          style: GoogleFonts.poppins(
                            height: 1.8,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.justify),
                      const SizedBox(
                        height: 5,
                      ),
                      Text("What causes a ${widget.diseaseName}?",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          )),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(widget.diseaseDescription![1],
                          style: GoogleFonts.poppins(
                            height: 1.8,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.justify),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Symtoms of ${widget.diseaseName}",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          )),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("\u2022 ${widget.bulletPoints![0]}",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.justify),
                            const SizedBox(
                              height: 5,
                            ),
                            Text("\u2022 ${widget.bulletPoints![1]}",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.justify),
                            const SizedBox(
                              height: 5,
                            ),
                            Text("\u2022 ${widget.bulletPoints![2]}",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.justify),
                            Text("\u2022 ${widget.bulletPoints![3]}",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.justify),
                            Text("\u2022 ${widget.bulletPoints![4]}",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.justify),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Treatment of ${widget.diseaseName}",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          )),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(widget.diseaseDescription![2],
                          style: GoogleFonts.poppins(
                            height: 1.8,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.justify),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Prevention of ${widget.diseaseName}",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          )),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(widget.diseaseDescription![3],
                          style: GoogleFonts.poppins(
                            height: 1.8,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.justify),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
