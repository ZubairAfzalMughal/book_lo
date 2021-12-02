import 'package:book_lo/screens/intro_screen.dart';
import 'package:flutter/material.dart';
import 'package:book_lo/utility/color_palette.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:splashscreen/splashscreen.dart';

class SecondarySplash extends StatelessWidget {
  const SecondarySplash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SplashScreen(
      title: Text(
        "Welcome to BOOK LO",
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0),
      ),
      seconds: 5,
      navigateAfterSeconds: IntroScreen(),
      backgroundColor: ColorPlatte.primaryColor,
      loaderColor: Colors.white,
      image: Image.asset(
        'assets/images/logo_splash.png',
        alignment: Alignment.center,
      ),
      photoSize: size.height * 0.3,
      useLoader: true,
    );
  }
}
