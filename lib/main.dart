import 'package:book_lo/screens/splash_screen.dart';
import 'package:book_lo/utility/color_palette.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: ColorPlatte.primaryColor),
      ),
      home: SecondarySplash(),
    );
  }
}
