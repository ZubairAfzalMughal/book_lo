import 'package:flutter/material.dart';

class Announcement extends StatelessWidget {
  const Announcement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (ctx, index) => ListTile(
          title: Text("Noman Sends to Message just ${index + 1} hours ago"),
        ),
      ),
    );
  }
}
