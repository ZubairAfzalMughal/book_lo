import 'package:book_lo/utility/color_palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileStat extends StatelessWidget {
  final int offer;
  final int request;

  ProfileStat({required this.offer, required this.request});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.12,
      decoration: BoxDecoration(
        color: ColorPlatte.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Offer\n$offer",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Request\n$request",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(
                      "ratings/${FirebaseAuth.instance.currentUser!.uid}/user")
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("0");
                } else if (snapshot.connectionState == ConnectionState.none) {
                  return Text("error");
                }
                int size = snapshot.data!.docs.length;
                int average = 0;
                snapshot.data!.docs.map((query) {
                  average += int.parse(query['ratings']);
                });
                int rating = average / size == 0 ? 1 : size;
                return Text(
                  "Rating\n$rating",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }),
        ],
      ),
    );
  }
}
