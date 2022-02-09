import 'package:book_lo/screens/map_screen.dart';
import 'package:book_lo/utility/color_palette.dart';
import 'package:book_lo/widgets/message_body.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../apis/chat.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;

  ChatScreen({required this.receiverId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final auth = FirebaseAuth.instance;

  final collection = FirebaseFirestore.instance;
  String col = "";
  TextEditingController controller = TextEditingController();
  generateCollection(String receiverId, String senderId) {
    if (receiverId.toLowerCase().codeUnits[0] >
        senderId.toLowerCase().codeUnits[0]) {
      return "$receiverId$senderId";
    } else {
      return "$senderId$receiverId";
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      col = generateCollection(widget.receiverId, auth.currentUser!.uid);
    });
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<DocumentSnapshot>(
            future: collection.collection('users').doc(widget.receiverId).get(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Text("Loading...");
              }
              Map<String, dynamic> user =
                  snapshot.data!.data() as Map<String, dynamic>;
              return Text(user['name']);
            }),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Showing Body of messages
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: collection
                    .collection('$col')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final messages = snapshot.data!.docs;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (ctx, index) {
                      Map<String, dynamic> data =
                          messages[index].data() as Map<String, dynamic>;
                      final message = Chat.fromJson(data);
                      return MessageBody(
                        message: message.message,
                        createdAt: message.createdAt,
                        senderId: message.senderId,
                        receiverId: message.receiverId,
                      );
                    },
                  );
                }),
          ),

          //Send Button with Text Fields
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
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
                    onPressed: () {
                      Chat chat = Chat(
                        senderId: auth.currentUser!.uid,
                        receiverId: widget.receiverId,
                        message: controller.text,
                        createdAt: DateFormat.jm().format(DateTime.now()),
                      );
                      collection.collection('$col').add(chat.toMap()).then((_) {
                        controller.clear();
                      }).catchError((e) {
                        print(e);
                      });

                      //Checking if collection of messages is not exists add user to the list of chats
                      collection.collection('$col').get().then(
                        (QuerySnapshot snapshot) {
                          if (snapshot.docs.length == 1) {
                            //mainting list of chat of users for sender
                            collection
                                .collection(
                                    'chat/${auth.currentUser!.uid}/list')
                                .add({
                              'senderId': auth.currentUser!.uid,
                              'receiverId': widget.receiverId
                            });
                            //mainting list of chat of users for receiver
                            collection
                                .collection('chat/${widget.receiverId}/list')
                                .add({
                              'receiverId': auth.currentUser!.uid,
                              'senderId': widget.receiverId
                            });
                          }
                        },
                      );
                    },
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
