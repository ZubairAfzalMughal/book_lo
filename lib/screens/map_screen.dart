import 'dart:async';
import 'package:book_lo/apis/location.dart';
import 'package:book_lo/map_model.dart';
import 'package:book_lo/utility/color_palette.dart';
import 'package:book_lo/widgets/profile_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MapScreen extends StatefulWidget {
  final String senderId;
  final String receiverId;
  const MapScreen({Key? key, required this.senderId, required this.receiverId})
      : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late StreamSubscription<Position> locationStream;
  MapController mapController = MapController();
  bool isLoading = false;
  List<LatLng> _points = [];
  List<Marker> _marker = [];
  @override
  void initState() {
    updateLocation();
    getSenderReceiver();
    super.initState();
  }

  getSenderReceiver() async {
    setState(() {
      isLoading = true;
    });
    FirebaseFirestore store = FirebaseFirestore.instance;
    CollectionReference location = store.collection('locations');
    CollectionReference users = store.collection('users');
    var sender = await location.doc(widget.senderId).get();
    var receiver = await location.doc(widget.receiverId).get();
    var me = await users.doc(widget.senderId).get();
    var notMe = await users.doc(widget.receiverId).get();

    if (sender.exists && receiver.exists) {
      _points.add(LatLng(sender['lat'], receiver['long']));
      _points.add(LatLng(receiver['lat'], receiver['long']));
    }

    for (int i = 0; i < _points.length; i++) {
      _marker.add(
        Marker(
          point: _points.elementAt(i),
          builder: (ctx) => ProfileImage(
            imageProvider: i == 0
                ? me['imgUrl'].toString().isNotEmpty
                    ? Image.network(me['imgUrl'], fit: BoxFit.cover)
                    : Image.asset('assets/images/empty_profile.png')
                : notMe['imgUrl'].toString().isNotEmpty
                    ? Image.network(notMe['imgUrl'])
                    : Image.asset(
                        'assets/images/empty_profile.png',
                        fit: BoxFit.cover,
                      ),
          ),
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  updateLocation() async {
    var auth = FirebaseAuth.instance;
    var collection = FirebaseFirestore.instance.collection('locations');
    locationStream = Geolocator.getPositionStream().listen((Position position) {
      collection.doc(auth.currentUser!.uid).update(
        {'lat': position.latitude, 'long': position.longitude},
      );
    });
  }

  @override
  void dispose() {
    locationStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(ColorPlatte.primaryColor),
              ),
            )
          : Stack(
              children: [
                FutureBuilder<DocumentSnapshot>(
                  future: Provider.of<MapProvider>(context, listen: false)
                      .getLocation(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation(ColorPlatte.primaryColor),
                        ),
                      );
                    }
                    //Mapping user location

                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    final location = UserLocation.fromMap(data);
                    return FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        center: LatLng(location.lat, location.long),
                        zoom: 11.0,
                      ),
                      layers: [
                        TileLayerOptions(
                          urlTemplate:
                              "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: ['a', 'b', 'c'],
                          attributionBuilder: (_) {
                            return Text(
                              "© BOOK LO",
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: ColorPlatte.primaryColor,
                              ),
                            );
                          },
                        ),
                        MarkerLayerOptions(
                          markers: _marker,
                        ),
                        PolylineLayerOptions(polylines: [
                          Polyline(
                              points: _points,
                              strokeWidth: 5,
                              color: Colors.red),
                        ]),
                      ],
                    );
                  },
                ),
                Positioned(
                  top: 30.0,
                  left: 20.0,
                  child: Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: ColorPlatte.primaryColor,
                        )),
                  ),
                ),
              ],
            ),
    );
  }
}
