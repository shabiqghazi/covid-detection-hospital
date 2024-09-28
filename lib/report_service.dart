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

class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> updateStatus(id, status) async {
    try {
      await _firestore.collection('reports').doc(id).update({
        'status': status,
      });
    } catch (e) {
      print("Error connecting to Firestore: $e");
    }
  }

  Future<dynamic> getStatus(userId, hospitalId) async {
    try {
      print("Attempting to connect to Firestore...");
      QuerySnapshot querySnapshot = await _firestore
          .collection('reports')
          .where(Filter.and(Filter('userId', isEqualTo: userId),
              Filter('hospitalId', isEqualTo: hospitalId)))
          .get();
      print(
          "Connection successful. Document count: ${querySnapshot.docs.length}");
      // List to hold combined data (test_history + user)
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs[0];
      }
    } catch (e) {
      print("Error connecting to Firestore: $e");
    }
    // Get data from docs and convert them to List
    return [];
  }

  Future<List<dynamic>> getDocs() async {
    try {
      print("Attempting to connect to Firestore...");
      QuerySnapshot querySnapshot =
          await _firestore.collection('reports').get();
      print(
          "Connection successful. Document count: ${querySnapshot.docs.length}");
      // List to hold combined data (test_history + user)
      List<dynamic> combinedData = [];

      for (QueryDocumentSnapshot testDoc in querySnapshot.docs) {
        // Step 2: Extract userId from each test_history document
        String userId = testDoc['userId'];

        // Step 3: Fetch user document based on userId
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(userId).get();

        if (userDoc.exists) {
          // Step 4: Combine the test_history data with user data
          Map<String, dynamic> testData =
              testDoc.data() as Map<String, dynamic>;
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;

          combinedData.add({
            'test_history': testData,
            'test_id': testDoc.id,
            'user': userData,
          });
        }
      }
      return combinedData;
    } catch (e) {
      print("Error connecting to Firestore: $e");
    }
    // Get data from docs and convert them to List
    return [];
  }
}
