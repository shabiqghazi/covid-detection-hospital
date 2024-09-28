import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Profilll {
  String name;
  String address;
  GeoPoint geoPoint;

  Profilll({required this.name, required this.address, required this.geoPoint});
}

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
      clientId:
          '293905643672-qtcctr5l2mk4l4t8vl4evi5un4vinis6.apps.googleusercontent.com');
  Future<Map<String, dynamic>> getProfile(userUid) async {
    try {
      print("Attempting to connect to Firestore...");
      print(userUid);
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('users').doc(userUid).get();
      print("Connection successful. User found");
      print(documentSnapshot.data());
      // List to hold combined data (test_history + user)
      if (documentSnapshot.exists) {
        return documentSnapshot.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print("Error connecting to Firestore: $e");
    }
    return {};
  }

  Future<void> updateProfile(userUid, data) async {
    try {
      double latitude = data['geoPoint'].latitude;
      double longitude = data['geoPoint'].longitude;
      print(latitude + longitude);
      await _firestore.collection('users').doc(userUid).update({
        'name': data['name'],
        'address': data['address'],
        'geoPoint': GeoPoint(latitude, longitude), // Store as GeoPoint
      });
    } catch (e) {
      print("Error connecting to Firestore: $e");
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
