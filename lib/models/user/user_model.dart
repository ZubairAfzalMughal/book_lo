import 'package:book_lo/apis/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  AppUser? _appUser;
  AppUser? get appUser => _appUser;
  CollectionReference userStore =
      FirebaseFirestore.instance.collection('users');
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<DocumentSnapshot> getUser() async {
    DocumentSnapshot doc = await userStore.doc(auth.currentUser!.uid).get();
    return doc;
  }

  Future signOut() async {
    await auth.signOut();
  }
}
