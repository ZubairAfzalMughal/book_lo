import 'package:book_lo/apis/location.dart';
import 'package:book_lo/map_model.dart';
import 'package:book_lo/utility/color_palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: Provider.of<MapProvider>(context, listen: false).getLocation(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(ColorPlatte.primaryColor),
              ),
            );
          }
          //Mapping user location

          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          final location = UserLocation.fromMap(data);
          return FlutterMap(
            options: MapOptions(
              center: LatLng(location.lat, location.long),
              zoom: 13.0,
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
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(location.lat, location.long),
                    builder: (ctx) => Icon(
                      Icons.pin_drop,
                      color: ColorPlatte.primaryColor,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
