import 'package:book_lo/screens/chat_screen.dart';
import 'package:book_lo/utility/color_palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Message"),
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(
                          'chat/${FirebaseAuth.instance.currentUser!.uid}/list')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text("Loading"),
                      );
                    }
                    final docs = snapshot.data!.docs;
                    return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final doc =
                              docs[index].data() as Map<String, dynamic>;
                          //displaying list of chat users
                          final userCol = doc['senderId'] ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? doc['receiverId']
                              : doc['senderId'];
                          return FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userCol)
                                  .get(),
                              builder: (context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (!snapshot.hasData) {
                                  return Text("");
                                }
                                final user = snapshot.data!.data()
                                    as Map<String, dynamic>;
                                return Card(
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => ChatScreen(
                                                receiverId: doc['receiverId'])),
                                      );
                                    },
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: user['imgUrl'].toString().isEmpty
                                          ? Image.asset(
                                              'assets/images/empty_profile.png')
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              child: Image.network(
                                                user['imgUrl'],
                                                height: 35.0,
                                                width: 35.0,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                    ),
                                    title: Text(
                                      user['name'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900),
                                    ),
                                    subtitle: Text(user['location']),
                                    trailing: Icon(
                                      Icons.location_on,
                                      color: ColorPlatte.primaryColor,
                                    ),
                                  ),
                                );
                              });
                        });
                  })),
        ],
      ),
    );
  }
}
