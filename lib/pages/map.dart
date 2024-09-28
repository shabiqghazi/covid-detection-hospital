import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  MapScreen({super.key, required this.hospitals, required this.center});
  List<dynamic> hospitals;
  GeoPoint center;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rumah Sakit di sekitar')),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(center.latitude, center.longitude),
          zoom: 9.5,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(markers: List.of(hospitals.map((hospital) {
            return Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(hospital['geoPoint'].latitude,
                  hospital['geoPoint'].longitude),
              builder: (ctx) => Column(
                children: [
                  const Icon(Icons.location_on, color: Colors.red, size: 40.0),
                  Text(
                    hospital['name'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10.0,
                        shadows: [
                          Shadow(color: Colors.white, blurRadius: 2.0)
                        ]),
                  )
                ],
              ),
            );
          }))),
        ],
      ),
    );
  }
}
