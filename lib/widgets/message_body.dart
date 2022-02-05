import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBody extends StatelessWidget {
  final String message;
  final String createdAt;
  final String senderId;
  final String receiverId;

  MessageBody({
    required this.message,
    required this.createdAt,
    required this.senderId,
    required this.receiverId,
  });

  final collection = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: collection.collection('users').doc(senderId).get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Text("");
          }
          Map<String, dynamic> user =
              snapshot.data!.data() as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: user['imgUrl'].toString().isEmpty
                    ? Image.asset('assets/images/empty_profile.png')
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Image.network(
                          user['imgUrl'],
                          height: 35.0,
                          width: 35.0,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user['name'],
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  Text(message),
                ],
              ),
              trailing: Text(createdAt),
            ),
          );
        });
  }
}
