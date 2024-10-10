import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportService {
  User? userAccount = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> updateStatus(id, status) async {
    try {
      await _firestore.collection('reports').doc(id).update({
        'status': status,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getStatus(userId, hospitalId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('reports')
          .where(Filter.and(Filter('userId', isEqualTo: userId),
              Filter('hospitalId', isEqualTo: hospitalId)))
          .get();
      // List to hold combined data (test_history + user)
      if (querySnapshot.docs.isNotEmpty) {
        return {
          'status': querySnapshot.docs[0]['status'],
          'id': querySnapshot.docs[0].id
        };
      }
    } catch (e) {
      rethrow;
    }
    // Get data from docs and convert them to List
    return [];
  }

  Future<List<dynamic>> getDocs() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('reports')
          .where('hospitalId', isEqualTo: userAccount!.uid)
          .get();
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
      rethrow;
    }
  }
}
