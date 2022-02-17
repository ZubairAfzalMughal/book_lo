// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:book_lo/apis/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostProvider extends ChangeNotifier {
  final auth = FirebaseAuth.instance;
  final userCollection = FirebaseFirestore.instance;
  final generalCollection = FirebaseFirestore.instance.collection('general');
  ImagePicker imagePicker = ImagePicker();
  FirebaseStorage firebaseStorageRef = FirebaseStorage.instance;
  List<String> _catList = [
    "science",
    "history",
    "arts",
    "biology",
    "physics",
    "mathematics",
    "fiction",
    "computer",
  ];
  String _title = "";
  String _desc = "";
  String _type = "";
  String _imgPath = "";
  String _category = "";
  bool _isLoading = false;
  File? _file;
  String _status = "";
  String get title => _title;

  String get type => _type;
  File? get file => _file;

  String get desc => _desc;

  bool get isLoading => _isLoading;

  String get imgPath => _imgPath;

  String get status => _status;

  String get category => _category;

  List<String> get catList => _catList;

  setTitle(String t) {
    _title = t;
    notifyListeners();
  }

  setDesc(String d) {
    _desc = d;
    notifyListeners();
  }

  setStatus(String s) {
    _status = s == "request" ? "request" : "offer";
    notifyListeners();
  }

  setCategory(String c) {
    _category = c;
    notifyListeners();
  }

  List<Book> _post = [];

  uploadImage() async {
    try {
      final pickedFile = await imagePicker.pickImage(
          source: ImageSource.camera, imageQuality: 85);
      if (pickedFile != null) {
        _file = File(pickedFile.path);
      } else {
        return;
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  clearPostValues() {
    _title = "";
    _desc = "";
    _imgPath = "";
    _category = "";
    _status = "";
    _file = null;
    notifyListeners();
  }

  Future uploadPost() async {
    try {
      final dir =
          firebaseStorageRef.ref().child('${auth.currentUser!.uid}/posts');
      UploadTask uploadTask =
          dir.child('${DateTime.now()}.jpg').putFile(_file!);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      final String url = (await snapshot.ref.getDownloadURL());
      _imgPath = url;
      //Uploading to user collection
      Book book = Book(
        userId: auth.currentUser!.uid,
        category: _category,
        imgUrl: _imgPath,
        description: _desc,
        createdAt: DateTime.now().toString(),
        status: _status,
        title: _title,
      );
      // userCollection
      //     .collection('posts/${auth.currentUser!.uid}/post')
      //     .add(book.toMap());
      //Uploading to general collection
      generalCollection.add(book.toMap());
    } catch (e) {
      return;
    }
    notifyListeners();
  }

  getBooks() {
    generalCollection.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        post.add(Book.fromMap(data));
      });
    });
    print(post.length);
  }

  List<Book> get post => _post;
}
