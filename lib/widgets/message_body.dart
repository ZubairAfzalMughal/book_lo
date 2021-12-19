import 'package:flutter/material.dart';

class MessageBody extends StatelessWidget {
  const MessageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      //TODO:Add user profile image here
      leading: CircleAvatar(),
      title: Text("Noman"),
      subtitle: Text("Hi there how are you"),
      trailing: Text("a minute ago"),
    );
  }
}
