import 'package:book_lo/utility/color_palette.dart';
import 'package:book_lo/widgets/profile_image.dart';
import 'package:flutter/material.dart';

class EditProfileImage extends StatelessWidget {
  const EditProfileImage(
      {required this.size, required this.imgProivder, required this.onTap});

  final Size size;
  final Widget imgProivder;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.2,
      child: Align(
        alignment: Alignment.topCenter,
        child: Stack(
          children: [
            ProfileImage(imageProvider: imgProivder),
            Positioned(
              bottom: 0.0,
              right: 0.0,
              child: GestureDetector(
                onTap: onTap,
                child: Icon(
                  Icons.camera_alt,
                  color: ColorPlatte.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
