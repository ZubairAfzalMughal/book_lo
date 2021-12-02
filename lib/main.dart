import 'package:book_lo/models/login/login_model.dart';
import 'package:book_lo/models/register/register_provider.dart';
import 'package:book_lo/screens/splash_screen.dart';
import 'package:book_lo/utility/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RegisterProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LoginProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: ColorPlatte.primaryColor,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: ColorPlatte.primaryColor),
      ),
      home: SecondarySplash(),
    );
  }
}
