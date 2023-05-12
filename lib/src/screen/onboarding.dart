import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skinsnap/src/screen/login_screen.dart';
import '../Utilities/constant.dart';
import '../Utilities/onboard_model.dart';
import 'package:google_fonts/google_fonts.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int currentIndex = 0;
  late PageController _pageController;
  List<OnboardModel> screens = <OnboardModel>[
    OnboardModel(
      img: 'assets/images/img-2.png',
      text: "Say No Doctor?",
      desc:
          "Check your skin from home. Save your time and life before detecting a mole early stage from the smartphone.",
      bg: Colors.white,
      button: const Color(0xFF4756DF),
    ),
    OnboardModel(
      img: 'assets/images/img-1.png',
      text: "Say No to Skin Diseases!",
      desc:
          "Check your skin on the smartphone and get\n instant results within 1 minute. \nTake a Photo",
      bg: Colors.white,
      button: const Color(0xFF4756DF),
    ),
    OnboardModel(
      img: 'assets/images/img-3.png',
      text: "Artificial Intelligence",
      desc:
          "Upload you photo to the Artificial Intelligence.\n The system will analyze it and give you a risk\n assessment.",
      bg: Colors.white,
      button: const Color(0xFF4756DF),
    ),
  ];

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _storeOnboardInfo() async {
    print("Shared pref called");
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isViewed);
    print(prefs.getInt('onBoard'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kwhite,
      appBar: AppBar(
        backgroundColor: kwhite,
        elevation: 0.0,
        actions: [
          TextButton(
            onPressed: () {
              _storeOnboardInfo();
              Navigator.pushReplacement(
                  context,
                  // ignore: prefer_const_constructors
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: Text(
              "Skip",
              style: GoogleFonts.poppins(
                  color: kblack, fontSize: 16.0, fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: PageView.builder(
            itemCount: screens.length,
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (int index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (_, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    screens[index].img,
                    height: 200,
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    height: 10.0,
                    child: ListView.builder(
                      itemCount: screens.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3.0),
                                width: currentIndex == index ? 25 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: currentIndex == index
                                      ? kbrown
                                      : kbrown300,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ]);
                      },
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Text(
                    screens[index].text,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: kblack,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Text(
                    screens[index].desc,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: kblack,
                    ),
                  ),
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: () async {
                      print(index);
                      if (index == screens.length - 1) {
                        await _storeOnboardInfo();
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      }

                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.bounceIn,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10),
                      decoration: BoxDecoration(
                          color: kblue,
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        screens.length - 1 != index
                            ? Text(
                                "Next",
                                style: TextStyle(fontSize: 18.0, color: kwhite),
                              )
                            : Text(
                                "Get Started",
                                style: TextStyle(fontSize: 18.0, color: kwhite),
                              ),
                        // ignore: prefer_const_constructors
                        screens.length - 1 != index
                            ? Icon(
                                Icons.arrow_forward_sharp,
                                color: kwhite,
                              )
                            : const SizedBox()
                      ]),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
