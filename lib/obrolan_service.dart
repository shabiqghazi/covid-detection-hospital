import 'package:cloud_firestore/cloud_firestore.dart';

class ObrolanService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  dynamic getChatRoomList(userId) {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> querySnapshot = _firestore
          .collection('chatRooms')
          .where('participants', arrayContains: userId)
          .where('lastMessage', isNotEqualTo: '')
          .orderBy('lastUpdate', descending: true)
          .snapshots();
      // List to hold combined data (test_history + user)
      return querySnapshot;
    } catch (e) {
      rethrow;
    }
  }
}
