import 'package:book_lo/utility/color_palette.dart';
import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final Widget imageProvider;

  const ProfileImage({Key? key, required this.imageProvider}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ColorPlatte.primaryColor, width: 2.0),
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: imageProvider,
      ),
    );
  }
}
