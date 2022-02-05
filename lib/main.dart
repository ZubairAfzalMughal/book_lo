import 'package:book_lo/map_model.dart';
import 'package:book_lo/models/Post/post_model.dart';
import 'package:book_lo/models/login/login_model.dart';
import 'package:book_lo/models/profile/edit_profile_model.dart';
import 'package:book_lo/models/register/register_provider.dart';
import 'package:book_lo/models/user/user_model.dart';
import 'package:book_lo/screens/splash_screen.dart';
import 'package:book_lo/utility/color_palette.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RegisterProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LoginProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PostProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MapProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: ColorPlatte.primaryColor,
          ),
          textTheme: GoogleFonts.montserratTextTheme(
            Theme.of(context).textTheme,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: ColorPlatte.primaryColor),
        ),
        home: FutureBuilder(
            future: Firebase.initializeApp(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Scaffold(
                  backgroundColor: ColorPlatte.primaryColor,
                );
              } else {
                return SecondarySplash();
              }
            }),
      ),
    );
  }
}
