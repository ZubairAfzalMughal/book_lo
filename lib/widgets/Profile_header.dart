import 'package:book_lo/utility/color_palette.dart';
import 'package:book_lo/widgets/profile_image.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String cityName;
  final Widget imgProvider;
  final Widget icon;
  ProfileHeader({
    required this.name,
    required this.cityName,
    required this.imgProvider,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            ProfileImage(imageProvider: imgProvider),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22.0),
                ),
                SizedBox(
                  width: 10.0,
                ),
                icon,
              ],
            ),
            Text(
              cityName,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: ColorPlatte.primaryColor,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
