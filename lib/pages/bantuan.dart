import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_detection_hospital/hospital_map_service.dart';
import 'package:covid_detection_hospital/pages/map.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class Bantuan extends StatefulWidget {
  const Bantuan({super.key});

  @override
  State<Bantuan> createState() => _BantuanState();
}

class _BantuanState extends State<Bantuan> {
  List<dynamic> _hospitals = [];
  bool _isLoading = true;
  GeoPoint _currentPosition = GeoPoint(-7.0, 108.0);

  // Meminta izin akses mikrofon
  Future<void> _requestPermissions() async {
    var location = await Permission.location.request();

    if (location != PermissionStatus.granted) {
      await openAppSettings();
    } else {
      await _getCurrentLocation();
    }
  }

  @override
  void initState() {
    _requestPermissions().then((context) {
      _fetchData();
    });
    super.initState();
  }

  Future<void> _fetchData() async {
    try {
      print(_currentPosition.latitude.toString() +
          ", " +
          _currentPosition.longitude.toString());
      HospitalMapService().getDocs(_currentPosition).then((hospitals) {
        setState(() {
          _hospitals = hospitals;
          _isLoading = false;
        });
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Mengambil lokasi saat ini
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = GeoPoint(position.latitude, position.longitude);
      });
      print('Posisi saat ini: $_currentPosition');
    } catch (e) {
      print('Gagal mendapatkan lokasi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green[600],
            ),
            child: MapScreen(hospitals: _hospitals, center: _currentPosition),
          ),
        ),
        Expanded(
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: _hospitals.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(_hospitals[index]['name']),
                  subtitle: Text(_hospitals[index]['address']),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.local_hospital,
                      size: 30,
                      color: Colors.pink,
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
