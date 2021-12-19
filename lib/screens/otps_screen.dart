import 'package:book_lo/models/register/register_provider.dart';
import 'package:book_lo/screens/bottom_navigation_bar.dart';
import 'package:book_lo/utility/color_palette.dart';
import 'package:book_lo/widgets/error_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class OtpScreens extends StatefulWidget {
  const OtpScreens({Key? key}) : super(key: key);

  @override
  State<OtpScreens> createState() => _OtpScreensState();
}

class _OtpScreensState extends State<OtpScreens> {
  @override
  void initState() {
    final reg = Provider.of<RegisterProvider>(context, listen: false);
    reg.auth.verifyPhoneNumber(
      phoneNumber: reg.phoneNumber,
      timeout: Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await phoneProvider.auth.signInWithCredential(credential);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => BottomNavigation(),
            ),
            (route) => false);
      },
      verificationFailed: _verificationFailed,
      codeSent: (String verificationId, int? resendToken) async {
        setState(() {
          otpCode = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String id) {
        setState(() {
          otpCode = id;
        });
      },
    );
    super.initState();
  }

  late String otpCode;
  final phoneProvider = RegisterProvider();
  @override
  Widget build(BuildContext context) {
    final reg = Provider.of<RegisterProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Phone Otp Verify"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Image.asset(
            'assets/images/book_logo.png',
            height: 200.0,
            width: 200.0,
          ),
          Text("Code will sent to ${reg.phoneNumber}"),
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
            onComplete: (sms) async {
              PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: otpCode, smsCode: sms);
              await reg.auth.signInWithCredential(credential).then((user) {
                reg.firebaseFirestore
                    .collection('users')
                    .doc(reg.auth.currentUser!.uid)
                    .update({
                  'isVerified': true,
                });
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => BottomNavigation()),
                    (route) => false);
              }).catchError((error) {
                showDialog(
                  context: context,
                  builder: (context) => ErrorLog(
                    text: error.toString(),
                  ),
                );
              });
            },
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Not receive message yet?"),
              SizedBox(
                width: 10.0,
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  "resend",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ColorPlatte.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _verificationFailed(FirebaseAuthException exception) {
    ErrorLog(text: exception.message ?? "");
  }
}
