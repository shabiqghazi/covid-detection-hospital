import 'package:cloud_firestore/cloud_firestore.dart';

class Hospital {
  final String? name;
  final String? address;
  final GeoPoint? geo_point;
  final String? role;

  Hospital(
      {required this.name,
      required this.address,
      required this.geo_point,
      required this.role});
}

class HospitalMapService {
  Future<List<dynamic>> getDocs(GeoPoint currentLocation) async {
    final distance = 0.5;

    final double lowerLat = currentLocation.latitude - distance;
    final double lowerLon = currentLocation.longitude - distance;
    final double greaterLat = currentLocation.latitude + distance;
    final double greaterLon = currentLocation.longitude + distance;
    final lesserGeopoint = GeoPoint(lowerLat, lowerLon);
    final greaterGeopoint = GeoPoint(greaterLat, greaterLon);
    print(lesserGeopoint.latitude.toString() +
        ", " +
        lesserGeopoint.longitude.toString());
    print(greaterGeopoint.latitude.toString() +
        ", " +
        greaterGeopoint.longitude.toString());
    try {
      print("Attempting to connect to Firestore...");
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'hospital')
          .where('geo_point',
              isGreaterThan: lesserGeopoint, isLessThan: greaterGeopoint)
          .get();
      print(
          "Connection successful. Document count: ${querySnapshot.docs.length}");
      final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      return allData;
    } catch (e) {
      print("Error connecting to Firestore: $e");
    }
    // Get data from docs and convert them to List
    return [];
  }
}
