import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_detection_hospital/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profilll {
  String name;
  String address;
  GeoPoint geoPoint;

  Profilll({required this.name, required this.address, required this.geoPoint});
}

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void showSnackbarMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<UserModel> getProfile(userUid) async {
    final docRef = _firestore.collection("users").doc(userUid);
    DocumentSnapshot doc = await docRef.get();
    return UserModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<void> updateProfile(userUid, data) async {
    try {
      double latitude = data['geoPoint'].latitude;
      double longitude = data['geoPoint'].longitude;
      await _firestore.collection('users').doc(userUid).update({
        'name': data['name'],
        'address': data['address'],
        'geoPoint': GeoPoint(latitude, longitude), // Store as GeoPoint
      });
    } catch (e) {
      rethrow;
    }
  }

  Future createUser(uid, email, name) async {
    final data = UserModel(
      name: name,
      address: '',
      role: 'user',
      geoPoint: GeoPoint(1.0, 1.0),
      createdAt: DateTime.now().toString(),
    );

    _firestore.collection("users").doc(uid).set(data.toJson()).then((_) {
      return 'success';
    }).catchError((e) {
      return 'failed';
    });
  }

  Future createUserWithEmailAndPassword(
      BuildContext context, emailAddress, password, name) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      await createUser(
        userCredential.user!.uid,
        userCredential.user!.email,
        name,
      );

      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackbarMessage(context, 'Password terlalu lemah.');
      } else if (e.code == 'email-already-in-use') {
        showSnackbarMessage(
            context, 'Email telah terdaftar. Gunakan email lain!');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future signInWithEmailAndPassword(
      BuildContext context, emailAddress, password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        showSnackbarMessage(context, 'Email atau password salah.');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      rethrow;
    }
  }
}
