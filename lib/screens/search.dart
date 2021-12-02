import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Book Lo"),
        centerTitle: true,
      ),
      body: Center(
        child: Text("Search"),
      ),
    );
  }
}
