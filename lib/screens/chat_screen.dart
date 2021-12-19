import 'package:book_lo/screens/map_screen.dart';
import 'package:book_lo/utility/color_palette.dart';
import 'package:book_lo/widgets/message_body.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Name"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Showing Body of messages
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: 20,
              itemBuilder: (ctx, index) {
                return MessageBody();
              },
            ),
          ),

          //Send Button with Text Fields
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10.0),
                    hintText: 'Typing...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              //send button
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MapScreen(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.location_on,
                      color: ColorPlatte.primaryColor,
                    ),
                  ),
                  IconButton(
                    color: ColorPlatte.primaryColor,
                    icon: Icon(Icons.send),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
