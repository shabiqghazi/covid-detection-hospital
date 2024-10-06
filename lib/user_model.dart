import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? name, address, role, createdAt;
  final GeoPoint? geoPoint;

  UserModel({
    this.name,
    this.address,
    this.role,
    this.geoPoint,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'role': role,
      'geoPoint': geoPoint,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] as String,
      address: json['address'] as String,
      role: json['role'] as String,
      geoPoint: json['geoPoint'] as GeoPoint,
      createdAt: json['createdAt'].toString() as String,
    );
  }
}
