import 'package:cloud_firestore/cloud_firestore.dart';

// class Riwayat {
//   final String? name;
//   final String? address;
//   final GeoPoint? geo_point;
//   final Float? dim;
//   final Float? size;
//   final Float? dispersi;
//   final String? result;
//   final String? status;
//   final String? test_date;
//   final String? test_place;
//   final String? test_type;
//   final String? hospital_id;

//   Riwayat({
//     required this.name,
//     required this.address,
//     required this.geo_point,
//     required this.dim,
//     required this.size,
//     required this.dispersi,
//     required this.result,
//     required this.status,
//     required this.test_date,
//     required this.test_place,
//     required this.test_type,
//     required this.hospital_id,
//   });
// }

class ObrolanService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  dynamic getChatRoomList(userId) {
    try {
      print("Attempting to connect to Firestore...");
      Stream<QuerySnapshot<Map<String, dynamic>>> querySnapshot = _firestore
          .collection('chatRooms')
          .where('participants', arrayContains: userId)
          .snapshots();
      print("Connection successful.");
      // List to hold combined data (test_history + user)
      return querySnapshot;
    } catch (e) {
      print("Error connecting to Firestore: $e");
    }
    // Get data from docs and convert them to List
    return [];
  }
}
