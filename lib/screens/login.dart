import 'package:book_lo/models/login/login_model.dart';
import 'package:book_lo/screens/bottom_navigation_bar.dart';
import 'package:book_lo/screens/register.dart';
import 'package:book_lo/utility/color_palette.dart';
import 'package:book_lo/widgets/animated_routes.dart';
import 'package:book_lo/widgets/error_dialog.dart';
import 'package:book_lo/widgets/sample_button.dart';
import 'package:book_lo/widgets/showIndicator.dart';
import 'package:book_lo/widgets/toggle_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

enum ToggleState { login, signUp }

class _LoginState extends State<Login> {
  ToggleState toggleState = ToggleState.login;
  final auth = FirebaseAuth.instance;
  final collection = FirebaseFirestore.instance.collection('admin');
  final _formKey = GlobalKey<FormState>();

  checkAdmin(String email) async {
    print("Checking admin");
    var length = await collection.snapshots().length;
    print(length);
    collection.snapshots().map((QuerySnapshot<Map<String, dynamic>> snapshot) {
      print("snapshot");
      print(snapshot.docs);
      snapshot.docs.map((query) {
        print(query.data()['email']);
        if (query.data()['email'] == email) {
          final snackBar = SnackBar(
            content: Text("User Status: Admin not allowed"),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          print("You are current as a admin");
          return;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.2,
                child: Image.asset(
                  'assets/images/book_logo.png',
                  height: 250.0,
                  width: 250.0,
                  fit: BoxFit.cover,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ToggleButton(
                      text: "login",
                      size: size,
                      btnColor: ColorPlatte.primaryColor,
                      isSelected: toggleState == ToggleState.login,
                      onPressed: () {
                        setState(() {
                          toggleState = ToggleState.login;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ToggleButton(
                      text: "Sign Up",
                      size: size,
                      btnColor: ColorPlatte.primaryColor,
                      isSelected: toggleState == ToggleState.signUp,
                      onPressed: () {
                        setState(() {
                          toggleState = ToggleState.signUp;
                        });
                      },
                    ),
                  ),
                ],
              ),

              //Toggle the form
              SizedBox(
                height: 10.0,
              ),
              toggleState == ToggleState.login ? buildForm(size) : Register(),
            ],
          ),
        ),
      ),
    );
  }

  Form buildForm(Size size) {
    return Form(
      key: _formKey,
      child: Consumer<LoginProvider>(builder: (_, login, __) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                validator: (email) =>
                    !email!.contains('@') ? "Enter valid Email" : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.emailAddress,
                onChanged: login.setEmail,
                decoration: InputDecoration(
                  errorBorder: ColorPlatte.inputBorder,
                  focusedErrorBorder: ColorPlatte.inputBorder,
                  hintText: 'Email',
                  prefixIcon: Icon(
                    Icons.email,
                    color: ColorPlatte.primaryColor,
                  ),
                  enabledBorder: ColorPlatte.inputBorder,
                  focusedBorder: ColorPlatte.inputBorder,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                obscureText: !login.showPassword,
                validator: (password) =>
                    password!.length < 6 ? "Too Short Password" : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: login.setPassowrd,
                decoration: InputDecoration(
                  errorBorder: ColorPlatte.inputBorder,
                  focusedErrorBorder: ColorPlatte.inputBorder,
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      login.showPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: ColorPlatte.primaryColor,
                    ),
                    onPressed: login.displayPassword,
                  ),
                  hintText: 'Password',
                  prefixIcon: Icon(
                    Icons.lock,
                    color: ColorPlatte.primaryColor,
                  ),
                  enabledBorder: ColorPlatte.inputBorder,
                  focusedBorder: ColorPlatte.inputBorder,
                ),
              ),
            ),
            SizedBox(height: 15.0),
            !login.isLoading
                ? SampleButton(
                    onPressed: () {
                      login.showLoader();
                      login.signIn(login.email, login.passowrd).then(
                        (value) {
                          if (!value.user!.emailVerified) {
                            login.offLoader();
                            login.auth.signOut();
                            showDialog(
                              context: context,
                              builder: (context) => ErrorLog(
                                text: "Verify Your Email Address",
                              ),
                            );
                            return;
                          }
                          login.offLoader();
                          login.clearFields();
                          Navigator.pushAndRemoveUntil(
                              context,
                              AnimatedRoutes(
                                routeWidget: BottomNavigation(),
                              ),
                              (route) => false);
                        },
                      ).catchError((error) {
                        login.offLoader();
                        showDialog(
                          context: context,
                          builder: (context) => ErrorLog(
                            text: error.message.toString(),
                          ),
                        );
                      });
                    },
                    text: 'Login',
                  )
                : loadingIndicator(),
            SizedBox(height: 25.0),
            GestureDetector(
              onTap: () {
                buildBottomSheet(size);
              },
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                    color: ColorPlatte.primaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      }),
    );
  }

  String fakeEmail = "";

  buildBottomSheet(Size size) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(top: size.height * 0.1),
          child: Column(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.cancel_outlined,
                    color: ColorPlatte.primaryColor,
                    size: 40.0,
                  )),
              Text(
                "Reset Password",
                style: TextStyle(
                  color: ColorPlatte.primaryColor,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                child: TextFormField(
                  onChanged: (value) => setState(() => fakeEmail = value),
                  decoration: InputDecoration(
                    hintText: 'email',
                    prefixIcon: Icon(
                      Icons.email,
                      color: ColorPlatte.primaryColor,
                    ),
                    enabledBorder: ColorPlatte.inputBorder,
                    focusedBorder: ColorPlatte.inputBorder,
                  ),
                ),
              ),
              SampleButton(
                  onPressed: () {
                    auth.sendPasswordResetEmail(email: fakeEmail).then((_) {
                      toast(
                          "link has been sent to your email for password reset");
                    }).catchError((error) {
                      showDialog(
                        context: context,
                        builder: (context) => ErrorLog(
                          text: error.message.toString(),
                        ),
                      );
                    });
                  },
                  text: "Submit")
            ],
          ),
        );
      },
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        toggleState == ToggleState.login ? "Login" : "Sign Up",
      ),
      automaticallyImplyLeading: false,
    );
  }
}
