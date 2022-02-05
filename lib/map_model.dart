import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class MapProvider extends ChangeNotifier {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot> getLocation() async {
    DocumentSnapshot doc = await _firestore
        .collection('locations')
        .doc(_firebaseAuth.currentUser!.uid)
        .get();
    return doc;
  }
}
