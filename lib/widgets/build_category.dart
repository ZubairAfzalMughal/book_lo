import 'package:book_lo/utility/color_palette.dart';
import 'package:flutter/material.dart';

class BuildCategory extends StatelessWidget {
  final int index;
  final String text;
  final VoidCallback onTap;
  const BuildCategory(
      {Key? key, required this.index, required this.text, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2.0),
        decoration: BoxDecoration(
          color: index == 1
              ? ColorPlatte.primaryColor
              : ColorPlatte.secondaryColor,
          borderRadius: BorderRadius.circular(17.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: index == 1 ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}
