import 'package:book_lo/utility/color_palette.dart';
import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildForm();
  }

  Form buildForm() {
    return Form(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'UserName',
                prefixIcon: Icon(
                  Icons.account_box,
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Confirm Password',
                prefixIcon: Icon(
                  Icons.lock,
                  color: ColorPlatte.primaryColor,
                ),
                enabledBorder: ColorPlatte.inputBorder,
                focusedBorder: ColorPlatte.inputBorder,
              ),
            ),
          ),
          //TODO: Add SignUp Button
        ],
      ),
    );
  }
}
