import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DrawerShimmer extends StatelessWidget {
  const DrawerShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Container(
              color: Colors.white,
            ),
          ),
        ),
        ...List.generate(
          10,
          (index) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              children: [
                Divider(),
                Container(
                  width: double.infinity,
                  height: 50.0,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ).toList(),
      ],
    );
  }
}
