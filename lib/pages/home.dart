import 'dart:async';
import 'package:covid_detection_hospital/auth_services.dart';
import 'package:covid_detection_hospital/pages/obrolan.dart';
import 'package:covid_detection_hospital/pages/pasien.dart';
import 'package:covid_detection_hospital/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final AuthServices _authServices = AuthServices();
  User? userAccount = FirebaseAuth.instance.currentUser;
  UserModel user = UserModel();

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchData() async {
    UserModel fetchUser = await AuthServices().getProfile(userAccount!.uid);
    if (fetchUser.role != "hospital") {
      await _confirmLogout(context);
    }
    setState(() {
      user = fetchUser;
    });
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
      if (!context.mounted) return;
      await _authServices.signOut(context);
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
              user.name?.isNotEmpty == true
                  ? 'Halo, ${user.name}!'
                  : userAccount?.displayName != null
                      ? 'Halo, ${userAccount!.displayName}!'
                      : 'Halo, ',
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
                      if (value == '/profile') {
                        Navigator.pushNamed(
                          context,
                          value,
                          arguments: userAccount!.uid,
                        );
                      } else if (value == 'logout') {
                        _confirmLogout(context);
                      } else {
                        Navigator.pushNamed(
                          context,
                          "$value",
                        );
                      }
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return const [
                      PopupMenuItem<String>(
                        value: '/profile',
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
                      PopupMenuItem<String>(
                        value: '/about',
                        child: Row(
                          children: [
                            Icon(Icons.info),
                            SizedBox(width: 8),
                            Text('Tentang'),
                          ],
                        ),
                      ),
                    ];
                  },
                  child: userAccount!.photoURL != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            userAccount!.photoURL!,
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
                  user: userAccount,
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
