import 'package:book_lo/models/register/register_provider.dart';
import 'package:book_lo/screens/login.dart';
import 'package:book_lo/utility/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtpScreens extends StatefulWidget {
  const OtpScreens({Key? key}) : super(key: key);

  @override
  State<OtpScreens> createState() => _OtpScreensState();
}

class _OtpScreensState extends State<OtpScreens> {
  logout() {
    final userAuth = Provider.of<RegisterProvider>(context,listen: false);
    userAuth.auth.signOut().then((_) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => Login(),
          ),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final emailAuth = Provider.of<RegisterProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify your email address"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Image.asset(
            'assets/images/book_logo.png',
            height: 200.0,
            width: 200.0,
          ),
          SizedBox(
            height: 5.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
                text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 22.0),
                    text: "We have sent you verification link on",
                    children: [
                  TextSpan(
                    text: "${emailAuth.auth.currentUser!.email}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorPlatte.primaryColor,
                    ),
                  ),
                  TextSpan(
                      text: "email address",
                      style: TextStyle(color: Colors.black)),
                ])),
          ),
          SizedBox(
            height: 10.0,
          ),
          ElevatedButton(
            style:
                TextButton.styleFrom(backgroundColor: ColorPlatte.primaryColor),
            onPressed: () {
              logout();
            },
            child: Text("Login"),
          ),
        ],
      ),
    );
  }
}
