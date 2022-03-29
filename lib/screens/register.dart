import 'package:book_lo/models/register/register_provider.dart';
import 'package:book_lo/screens/otps_screen.dart';
import 'package:book_lo/utility/color_palette.dart';
import 'package:book_lo/widgets/error_dialog.dart';
import 'package:book_lo/widgets/sample_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildForm(context);
  }

  //Warning : If you run the app it will show the late intializaion error

  Container buildForm(context) {
    return Container(
      child: Consumer<RegisterProvider>(builder: (_, register, __) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                onChanged: register.setName,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  errorText: register.name.isEmpty ? "Enter valid Name" : null,
                  errorBorder: ColorPlatte.inputBorder,
                  focusedErrorBorder: ColorPlatte.inputBorder,
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
                keyboardType: TextInputType.number,
                maxLength: 12,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: register.setPhoneNumber,
                decoration: InputDecoration(
                  errorText: register.phoneNumber.isEmpty
                      ? "Enter valid Number"
                      : null,
                  errorBorder: ColorPlatte.inputBorder,
                  focusedErrorBorder: ColorPlatte.inputBorder,
                  hintText: '92xxxxxxxxx',
                  prefixIcon: Icon(
                    Icons.phone_android,
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
                onChanged: register.setEmail,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  errorText: !register.email.contains('@')
                      ? "Enter Valid Email"
                      : null,
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
                obscureText: !register.showPassword,
                onChanged: register.setPassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  errorText: register.password.length < 6
                      ? "Too Short Passowrd"
                      : null,
                  errorBorder: ColorPlatte.inputBorder,
                  focusedErrorBorder: ColorPlatte.inputBorder,
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      register.showPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: ColorPlatte.primaryColor,
                    ),
                    onPressed: register.displayPassword,
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                obscureText: !register.showConfirmPassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: register.setConfirmPassword,
                decoration: InputDecoration(
                  errorText: (register.confirmPassword.isEmpty &&
                          register.password != register.confirmPassword)
                      ? "Password not Matched"
                      : null,
                  errorBorder: ColorPlatte.inputBorder,
                  focusedErrorBorder: ColorPlatte.inputBorder,
                  hintText: 'Confirm Password',
                  prefixIcon: Icon(
                    Icons.lock,
                    color: ColorPlatte.primaryColor,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      register.showConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: ColorPlatte.primaryColor,
                    ),
                    onPressed: register.displayConfirmPassword,
                  ),
                  enabledBorder: ColorPlatte.inputBorder,
                  focusedBorder: ColorPlatte.inputBorder,
                ),
              ),
            ),
            !register.isLoading
                ? SampleButton(
                    onPressed: () async {
                      register.showLoader();
                      register
                          .registeration(register.email, register.password)
                          .then(
                        (value) async {
                          register.offLoader();
                          register.firebaseFirestore
                              .collection('users')
                              .doc(register.auth.currentUser!.uid)
                              .set({
                            'name': register.name,
                            'email': register.email,
                            'phone': register.phoneNumber,
                            'isVerified': false,
                            "imgUrl": "",
                            'location': "",
                          });
                          //sending email link to user for verification
                          await register.auth.currentUser!
                              .sendEmailVerification();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OtpScreens(),
                              ),
                              (route) => false);
                        },
                      ).catchError((error) {
                        register.offLoader();
                        showDialog(
                          context: context,
                          builder: (_) => ErrorLog(
                            text: error.toString(),
                          ),
                        );
                      });
                    },
                    text: 'Register',
                  )
                : CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation(ColorPlatte.primaryColor),
                  ),
          ],
        );
      }),
    );
  }
}
