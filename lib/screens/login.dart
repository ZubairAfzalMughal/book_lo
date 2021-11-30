import 'package:book_lo/screens/register.dart';
import 'package:book_lo/utility/color_palette.dart';
import 'package:book_lo/widgets/toggle_button.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

enum ToggleState { login, signUp }

class _LoginState extends State<Login> {
  ToggleState toggleState = ToggleState.login;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.2,
              ),
              //logo
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
              toggleState == ToggleState.login ? buildForm() : Register(),
            ],
          ),
        ),
      ),
    );
  }

  Form buildForm() {
    return Form(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormField(
              decoration: InputDecoration(
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
              decoration: InputDecoration(
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
          //TODO: Add Login Button
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text('Book Lo'),
      centerTitle: true,
    );
  }
}
