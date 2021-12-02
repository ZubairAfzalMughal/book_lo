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
            title: "Finding Books is Diffult! 😥",
            body:
                "Some people have books they do not need after reading them, and others cannot afford to purchase the books they want to read",
            image: SvgPicture.asset('assets/svg_images/intro_2.svg'),
          ),
          PageViewModel(
            title: "What is Book Lo",
            body:
                "Our aim is to reduce the shortage of required books by developing a plateform that effectively allows people to share books online and in person. ",
            image: SvgPicture.asset('assets/svg_images/intro_3.svg'),
          ),
          PageViewModel(
            title: "Let\'s Start 😀",
            body:
                "it will empower the people to strengthen their communities and aim to accomplish"
                "this through technology",
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
