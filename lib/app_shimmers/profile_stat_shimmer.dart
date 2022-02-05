import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileStatShimmer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: size.height * 0.12,
        color: Colors.grey,
      ),
    );
  }
}
