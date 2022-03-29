import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: List.generate(
        5,
        (index) => Container(
          height: size.height * 0.2,
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: size.height * 0.3,
                  width: size.width * 0.3,
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: size.height * 0.02,
                        width: size.height * 0.04,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: size.height * 0.02,
                        width: size.height * 0.2,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: size.height * 0.02,
                            width: size.width * 0.03,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: size.height * 0.02,
                            width: size.width * 0.03,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: size.height * 0.02,
                            width: size.width * 0.06,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: size.height * 0.02,
                            width: size.width * 0.5,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ).toList(),
    );
  }
}
