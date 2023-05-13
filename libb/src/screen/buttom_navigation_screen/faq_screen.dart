import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  bool isExpanded = false;
  bool isTapped = true;

  List<Map<String, dynamic>> questions = [
    {
      "questions": "Early Detection Make a Difference?",
      "answers": [
        'It is an app that uses artificial intelligence to detect potential skin diseases by analyzing photos of moles, lesions, and rashes. Early detection allows for timely treatment and can potentially save lives.',
        'Users can take a photo of their skin concern and upload it to the app. The app uses machine learning algorithms to analyze the image and compare it to a database of known skin conditions. It then provides a list of possible diagnoses and recommends the user to seek medical attention if necessary.',
        'The app can help detect potential skin diseases at an early stage, which can lead to better treatment outcomes and potentially save lives. It also provides a convenient and accessible way for users to monitor their skin health and seek medical attention if needed.'
      ]
    },
    {
      "questions": "How is ML used in the application?",
      "answers": [
        'The app uses machine learning algorithms to analyze the image and compare it to a database of known skin conditions. It then provides a list of possible diagnoses and recommends the user to seek medical attention if necessary.',
        'The app can help detect potential skin diseases at an early stage, which can lead to better treatment outcomes and potentially save lives. It also provides a convenient and accessible way for users to monitor their skin health and seek medical attention if needed.',
        'The app uses machine learning algorithms to analyze the image and compare it to a database of known skin conditions. It then provides a list of possible diagnoses and recommends the user to seek medical attention if necessary.'
      ]
    },
    {
      "questions": "What is AI Dermatologist?",
      "answers": [
        'It is an app that uses artificial intelligence to detect potential skin diseases by analyzing photos of moles, lesions, and rashes. Early detection allows for timely treatment and can potentially save lives.',
        'Users can take a photo of their skin concern and upload it to the app. The app uses machine learning algorithms to analyze the image and compare it to a database of known skin conditions. It then provides a list of possible diagnoses and recommends the user to seek medical attention if necessary.',
        'The app can help detect potential skin diseases at an early stage, which can lead to better treatment outcomes and potentially save lives. It also provides a convenient and accessible way for users to monitor their skin health and seek medical attention if needed.'
      ]
    },
    {
      "questions": "How to take photo?",
      "answers": [
        'Users can take a photo of their skin concern and upload it to the app. The app uses machine learning algorithms to analyze the image and compare it to a database of known skin conditions. It then provides a list of possible diagnoses and recommends the user to seek medical attention if necessary.',
        'The app can help detect potential skin diseases at an early stage, which can lead to better treatment outcomes and potentially save lives. It also provides a convenient and accessible way for users to monitor their skin health and seek medical attention if needed.',
        'Users can take a photo of their skin concern and upload it to the app. The app uses machine learning algorithms to analyze the image and compare it to a database of known skin conditions. It then provides a list of possible diagnoses and recommends the user to seek medical attention if necessary.'
      ]
    },
    {
      "questions": "How to use?",
      "answers": [
        'Users can take a photo of their skin concern and upload it to the app. The app uses machine learning algorithms to analyze the image and compare it to a database of known skin conditions. It then provides a list of possible diagnoses and recommends the user to seek medical attention if necessary.',
        'The app can help detect potential skin diseases at an early stage, which can lead to better treatment outcomes and potentially save lives. It also provides a convenient and accessible way for users to monitor their skin health and seek medical attention if needed.',
        'Users can take a photo of their skin concern and upload it to the app. The app uses machine learning algorithms to analyze the image and compare it to a database of known skin conditions. It then provides a list of possible diagnoses and recommends the user to seek medical attention if necessary.'
      ]
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white24,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            )),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white24,
            child: Column(
              children: [
                const Text(
                  "FAQ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontFamily: "Poppins",
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(children: [
                    for (var i = 0; i < questions.length; i++) ...{
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: Colors.black38, width: 1.5)),
                        child: ExpansionTile(
                          title: Text(
                            questions[i]["questions"]!,
                            style: GoogleFonts.poppins(
                                color: Colors.black87,
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                          ),
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          childrenPadding:
                              const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          children: [
                            for (var j = 0;
                                j < questions[i]["answers"]!.length;
                                j++) ...{
                              Text(
                                "Step ${j + 1}:",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                questions[i]["answers"][j]!,
                                style: GoogleFonts.poppins(
                                  color: Colors.black87,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 10),
                            },
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    }
                  ]),
                )
              ],
            ),
          ),
        ));
  }
}
