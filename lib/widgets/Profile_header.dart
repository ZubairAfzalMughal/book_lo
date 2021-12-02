import 'package:book_lo/utility/color_palette.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String cityName;
  final String imgUrl;
  ProfileHeader({
    required this.name,
    required this.cityName,
    required this.imgUrl,
  });
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height * 0.3,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: ColorPlatte.primaryColor, width: 2.0),
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Image.asset(
                  imgUrl,
                  height: 100.0,
                  width: 100.0,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              name,
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22.0),
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
