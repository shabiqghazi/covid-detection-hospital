import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_detection_hospital/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  GeoPoint _location = GeoPoint(0.0, 0.0);
  bool isLoading = true;
  bool editMode = false;
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchProfile();
    });
  }

  Future<void> _fetchProfile() async {
    try {
      final User arguments = ModalRoute.of(context)?.settings.arguments as User;
      AuthServices().getProfile(arguments.uid).then((profile) {
        _nameController.text = profile['name'];
        _addressController.text = profile['address'];

        if (profile['geoPoint'] != GeoPoint(0.0, 0.0)) {
          GeoPoint location = profile['geoPoint'];
          setState(() {
            _location = location;
            isLoading = false;
          });
        }
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          title: const Text(
            'Profil',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      editMode = !editMode;
                    });
                  },
                  style: ButtonStyle(
                      foregroundColor:
                          const WidgetStatePropertyAll(Colors.white),
                      backgroundColor: !editMode
                          ? const WidgetStatePropertyAll(Colors.green)
                          : const WidgetStatePropertyAll(Colors.red)),
                  child: !editMode ? const Text('Edit') : const Text('Batal')),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              TextFormField(
                readOnly: !editMode,
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                readOnly: !editMode,
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Alamat'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Lokasi'),
              SizedBox(
                height: 260.0,
                child: !isLoading
                    ? FlutterMap(
                        options: MapOptions(
                          center:
                              LatLng(_location.latitude, _location.longitude),
                          maxZoom: 15.0,
                          zoom: 9.5,
                          onTap: editMode
                              ? (tapPosition, point) {
                                  setState(() {
                                    _location = GeoPoint(
                                        point.latitude, point.longitude);
                                  });
                                }
                              : null,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.app',
                          ),
                          MarkerLayer(markers: [
                            Marker(
                              width: 80.0,
                              height: 80.0,
                              point: LatLng(
                                  _location.latitude, _location.longitude),
                              builder: (ctx) => Column(
                                children: [
                                  const Icon(Icons.location_on,
                                      color: Colors.red, size: 40.0),
                                  Text(
                                    _nameController.text,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.0,
                                        shadows: [
                                          Shadow(
                                              color: Colors.white,
                                              blurRadius: 2.0)
                                        ]),
                                  )
                                ],
                              ),
                            )
                          ]),
                        ],
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: editMode
                    ? () {
                        final User arguments =
                            ModalRoute.of(context)?.settings.arguments as User;
                        dynamic data = {
                          'name': _nameController.text,
                          'address': _addressController.text,
                          'geoPoint':
                              GeoPoint(_location.latitude, _location.longitude)
                        };
                        AuthServices().updateProfile(arguments.uid, data);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Berhasil ubah profil'),
                            duration: Duration(
                                seconds:
                                    3), // Duration the Snackbar will be visible
                            backgroundColor: Colors.lightGreen,
                          ),
                        );
                      }
                    : null,
                style: const ButtonStyle(
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                    backgroundColor: WidgetStatePropertyAll(Colors.teal)),
                child: const Text('Submit'),
              )
            ],
          ),
        ));
  }
}
