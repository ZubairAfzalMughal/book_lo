import 'package:flutter/material.dart';

class OfferTab extends StatelessWidget {
  const OfferTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverGrid.count(
      crossAxisCount: 3,
      children: [
        Image.asset("assets/images/post1.jpg"),
      ],
    );
  }
}
