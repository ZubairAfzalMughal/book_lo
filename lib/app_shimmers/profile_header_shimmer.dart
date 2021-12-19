import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileHeaderShimmer extends StatelessWidget {
  const ProfileHeaderShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 200.0,
        color: Colors.grey,
      ),
    );
  }
}
