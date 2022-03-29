import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Announcement extends StatefulWidget {
  const Announcement({Key? key}) : super(key: key);

  @override
  State<Announcement> createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
  late StreamSubscription _subscription;
  @override
  void initState() {
    _subscription = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      Map<String, dynamic> toMap = {
        'title': notification?.title,
        'body': notification?.body
      };

      FirebaseFirestore.instance.collection('notificaions').add(toMap);

      //Creating Awesome flutter notifications

      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: DateTime.now().microsecond,
          channelKey: 'basic_channel',
          title: notification?.title,
          body: notification?.body,
          displayOnBackground: true,
          displayOnForeground: true,
        ),
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('notificaions').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text("Loading..."),
            );
          } else {
            return snapshot.data!.docs.length > 0
                ? ListView(
                    children: snapshot.data!.docs
                        .map(
                          (data) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ListTile(
                              tileColor: Colors.grey[300],
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    AssetImage('assets/images/book_logo.png'),
                              ),
                              title: Text(
                                data['title'],
                              ),
                              subtitle: Text(
                                data['body'],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  )
                : Center(
                    child: Text("No Notification yet"),
                  );
          }
        },
      ),
    );
  }
}
