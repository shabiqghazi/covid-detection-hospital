import 'dart:async';
import 'package:covid_detection_hospital/auth_services.dart';
import 'package:covid_detection_hospital/pages/obrolan.dart';
import 'package:covid_detection_hospital/pages/pasien.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final AuthServices _authServices = AuthServices();
  User? user = FirebaseAuth.instance.currentUser;
  Position? _currentPosition;

  @override
  void initState() {
    _requestPermissions();
    super.initState();
  }

  // Meminta izin akses mikrofon
  Future<void> _requestPermissions() async {
    var location = await Permission.location.request();

    if (location != PermissionStatus.granted) {
      await openAppSettings();
    } else {
      await _getCurrentLocation();
    }
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _authServices.signOut();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  // Mengambil lokasi saat ini
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });
      print('Posisi saat ini: $_currentPosition');
    } catch (e) {
      print('Gagal mendapatkan lokasi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            title: Text(
              user != null ? 'Halo, ${user!.displayName}' : 'Hello, User!',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: PopupMenuButton<String>(
                  onSelected: (value) {
                    // Gunakan Future.microtask untuk menangani kode asinkron
                    Future.microtask(() async {
                      if (value == 'profile') {
                        // Aksi untuk Profile
                        Navigator.pushNamed(context, '/profil',
                            arguments: user);
                      } else if (value == 'logout') {
                        _confirmLogout(context);
                      }
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return const [
                      PopupMenuItem<String>(
                        value: 'profile',
                        child: Row(
                          children: [
                            Icon(Icons.person),
                            SizedBox(width: 8),
                            Text('Profile'),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(Icons.logout),
                            SizedBox(width: 8),
                            Text('Logout'),
                          ],
                        ),
                      ),
                    ];
                  },
                  child: user != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            user!.photoURL!,
                            width: 30,
                          ),
                        )
                      : const Icon(
                          Icons.account_circle,
                          size: 30,
                          color: Colors.white,
                        ),
                ),
              ),
            ],
            bottom: const TabBar(
              unselectedLabelColor: Colors.white70,
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  text: 'Obrolan',
                ),
                Tab(
                  text: 'Pasien',
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: TabBarView(
              children: <Widget>[
                Obrolan(
                  user: user,
                ),
                const Pasien(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
