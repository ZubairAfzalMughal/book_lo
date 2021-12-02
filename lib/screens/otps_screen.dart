import 'package:book_lo/screens/bottom_navigation_bar.dart';
import 'package:book_lo/utility/color_palette.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';

class OtpScreens extends StatefulWidget {
  const OtpScreens({Key? key}) : super(key: key);

  @override
  State<OtpScreens> createState() => _OtpScreensState();
}

class _OtpScreensState extends State<OtpScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Lo"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Image.asset(
            'assets/images/book_logo.png',
            height: 200.0,
            width: 200.0,
          ),
          PinCodeFields(
            borderColor: ColorPlatte.primaryColor,
            keyboardType: TextInputType.number,
            fieldBorderStyle: FieldBorderStyle.Square,
            responsive: false,
            fieldHeight: 40.0,
            fieldWidth: 40.0,
            length: 6,
            animationDuration: const Duration(milliseconds: 200),
            animationCurve: Curves.easeInOut,
            switchInAnimationCurve: Curves.easeIn,
            switchOutAnimationCurve: Curves.easeOut,
            borderWidth: 2.0,
            animation: Animations.SlideInDown,
            onComplete: (output) {
              if (output == "000000") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BottomNavigation(),
                  ),
                );
              }
            },
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }
}
