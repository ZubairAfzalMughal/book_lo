import 'dart:io';
import 'package:book_lo/apis/interest.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileProvider extends ChangeNotifier {
  String _name = "";
  String _age = "";
  ImagePicker imagePicker = ImagePicker();
  FirebaseStorage firebaseStorageRef = FirebaseStorage.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference collection =
      FirebaseFirestore.instance.collection('users');
  bool _isHud = false;
  List<Interest> _interest = [
    Interest(name: "Science", isSelected: false),
    Interest(name: "Technology", isSelected: false),
    Interest(name: "History", isSelected: false),
    Interest(name: "Novel", isSelected: false),
    Interest(name: "Arts", isSelected: false),
    Interest(name: "Notes", isSelected: false),
    Interest(name: "Poetry", isSelected: false),
  ];
  bool get isHud => _isHud;
  String get name => _name;
  String get age => _age;
  List<Interest> get interest => _interest;

  void editName(String n) {
    this._name = n;
    notifyListeners();
  }

  void editAge(String a) {
    this._age = a;
    notifyListeners();
  }

  void setInterest(Interest i, bool selected) {
    List<Interest> temp = this._interest;
    //Getting index
    int index = this._interest.indexOf(i);
    //creating a temp variable
    temp[index].isSelected = selected;
    //Updating the list
    this._interest = temp;
    notifyListeners();
  }

  void showHud() {
    _isHud = true;
    notifyListeners();
  }

  void offHud() {
    _isHud = false;
    notifyListeners();
  }
  //setting Profile

  uploadToFirebase() async {
    try {
      final pickedFile =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final imgPath = File(pickedFile.path);
        final dir =
            firebaseStorageRef.ref().child('${auth.currentUser!.uid}/profile');
        UploadTask uploadTask =
            dir.child('${DateTime.now()}.jpg').putFile(imgPath);
        TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
        final String url = (await snapshot.ref.getDownloadURL());
        collection.doc(auth.currentUser!.uid).update({
          'imgUrl': url,
        });
      } else {
        return;
      }
    } catch (e) {
      print(e.toString());
    }

    notifyListeners();
  }
}
