import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:book_lo/apis/location.dart';
import 'package:book_lo/screens/messages.dart';
import 'package:book_lo/screens/notification.dart';
import 'package:book_lo/screens/home.dart';
import 'package:book_lo/screens/profile.dart';
import 'package:book_lo/screens/add_book.dart';
import 'package:book_lo/utility/color_palette.dart';
import 'package:book_lo/widgets/animated_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    Announcement(),
    Message(),
    Profile(),
  ];

  late PageController _pageController;
  late UserLocation userLocation;
  late StreamSubscription<ConnectivityResult> subscription;
  bool isInternet = false;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);

    //checking internet connection

    subscription =
        Connectivity().onConnectivityChanged.listen(checkConnectivityStatus);

    locationInitialization().then((location) {
      userLocation =
          UserLocation(lat: location.latitude, long: location.longitude);
      addLocationToDataBase();
    });

    //Getting permission of notification in case permission is not enabled

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Allow Notifications"),
            actions: [
              TextButton(
                onPressed: () => AwesomeNotifications()
                    .requestPermissionToSendNotifications(),
                child: const Text("Yes"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("No"),
              ),
            ],
          ),
        );
      }
    });

    super.initState();
  }

  checkConnectivityStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.mobile) {
      this.isInternet = true;
    } else if (result == ConnectivityResult.wifi) {
      this.isInternet = true;
    } else {
      this.isInternet = false;
    }
    setState(() {});
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
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !isInternet
        ? Scaffold(
            appBar: AppBar(
              title: Text("Oops! No Internet Connection"),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_off,
                    size: 100.0,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            body: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: _pages,
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    AnimatedRoutes(
                      routeWidget: AddBook(),
                    ),
                  );
                },
                child: Icon(Icons.add)),
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
                _pageController.jumpToPage(currentIndex);
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
                BottomNavigationBarItem(
                    icon: Icon(Icons.notifications), label: ''),
                BottomNavigationBarItem(
                  icon: Icon(Icons.mail),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle_outlined),
                  label: '',
                ),
              ],
            ),
          );
  }
}
