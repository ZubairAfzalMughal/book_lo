import 'package:book_lo/utility/color_palette.dart';
import 'package:flutter/material.dart';

class ToggleButton extends StatelessWidget {
  const ToggleButton(
      {Key? key,
      required this.size,
      required this.btnColor,
      required this.isSelected,
      required this.onPressed,
      required this.text})
      : super(key: key);
  final VoidCallback onPressed;
  final Size size;
  final Color btnColor;
  final bool isSelected;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width / 2,
      height: 50.0,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(isSelected
              ? ColorPlatte.primaryColor
              : ColorPlatte.secondaryColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
              fontSize: 20.0,
              color: isSelected ? Colors.white : ColorPlatte.primaryColor),
        ),
      ),
    );
  }
}
