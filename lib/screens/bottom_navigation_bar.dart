import 'package:book_lo/apis/location.dart';
import 'package:book_lo/screens/notification.dart';
import 'package:book_lo/screens/home.dart';
import 'package:book_lo/screens/profile.dart';
import 'package:book_lo/screens/add_book.dart';
import 'package:book_lo/utility/color_palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class BottomNavigation extends StatefulWidget {
  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentIndex = 0;
  List<Widget> _pages = [
    Home(),
    AddBook(),
    Announcement(),
    Profile(),
  ];
  late UserLocation userLocation;
  @override
  void initState() {
    locationInitialization().then((location) {
      userLocation =
          UserLocation(lat: location.latitude, long: location.longitude);
      addLocationToDataBase();
    });
    super.initState();
  }

  addLocationToDataBase() async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(userLocation.lat, userLocation.long);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    final id = auth.currentUser!.uid;
    firestore.collection('users').doc(id).update({
      'location': placemark[0].country,
    });
    firestore.collection('locations').doc(id).set({
      'lat': userLocation.lat,
      'long': userLocation.long,
    });
  }

  Future<Position> locationInitialization() async {
    await Geolocator.requestPermission();
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 2.0,
        selectedItemColor: ColorPlatte.primaryColor,
        unselectedItemColor: Colors.black,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_rounded), label: ''),
          BottomNavigationBarItem(
              icon: Badge(
                badgeContent: Text('11'),
                borderRadius: BorderRadius.circular(5),
                animationType: BadgeAnimationType.fade,
                child: Icon(Icons.notifications),
              ),
              label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: '',
          ),
        ],
      ),
    );
  }
}
