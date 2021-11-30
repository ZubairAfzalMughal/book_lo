import 'package:book_lo/screens/login.dart';
import 'package:book_lo/utility/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IntroductionScreen(
        globalBackgroundColor: Colors.white,
        animationDuration: 3,
        curve: Curves.fastLinearToSlowEaseIn,
        dotsDecorator: const DotsDecorator(
          size: Size(10.0, 10.0),
          activeColor: Color(0xFF0F2C67),
          color: Color(0xFFD3D3D3),
          activeSize: Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
        pages: [
          PageViewModel(
            title: "Iasdf",
            body: "Basd",
            image: SvgPicture.asset('assets/svg_images/intro_1.svg'),
          ),
          PageViewModel(
            title: "Iasf",
            body: "Basfee",
            image: SvgPicture.asset('assets/svg_images/intro_2.svg'),
          ),
          PageViewModel(
            title: "Iasff",
            body: "Baff",
            image: SvgPicture.asset('assets/svg_images/intro_3.svg'),
          ),
          PageViewModel(
            title: "I",
            body: "adf",
            image: SvgPicture.asset('assets/svg_images/intro_4.svg'),
          ),
        ],
        onDone: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Login(),
            ),
          );
        },
        onSkip: () {},
        showSkipButton: true,
        showNextButton: true,
        skip: buildButton(
          Text(
            "Skip",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        next: buildButton(
          Text(
            "Next",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        done: buildButton(
          Text(
            "Done",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  buildButton(Widget child) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: ColorPlatte.primaryColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: child,
    );
  }
}
