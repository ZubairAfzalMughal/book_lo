import 'dart:async';

import 'package:book_lo/models/register/register_provider.dart';
import 'package:book_lo/screens/bottom_navigation_bar.dart';
import 'package:book_lo/screens/intro_screen.dart';
import 'package:book_lo/utility/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:splashscreen/splashscreen.dart';

class SecondarySplash extends StatefulWidget {
  const SecondarySplash({Key? key}) : super(key: key);

  @override
  State<SecondarySplash> createState() => _SecondarySplashState();
}

class _SecondarySplashState extends State<SecondarySplash> {
  bool isLoggedIn = false;
  late StreamSubscription _streamSubscription;
  @override
  void initState() {
    final logger = Provider.of<RegisterProvider>(context, listen: false);
    _streamSubscription = logger.auth.userChanges().listen((user) {
      if (user != null) {
        setState(() {
          isLoggedIn = true;
        });
      } else {
        setState(() {
          isLoggedIn = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

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
      navigateAfterSeconds: isLoggedIn ? BottomNavigation() : IntroScreen(),
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
