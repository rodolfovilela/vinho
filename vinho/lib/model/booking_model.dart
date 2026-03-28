import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String? id;
  final String eventId;
  final int paxCount;
  final String name;
  final String email;
  final String phone;
  final DateTime? createdAt;

  BookingModel({
    this.id,
    required this.eventId,
    required this.paxCount,
    required this.name,
    required this.email,
    required this.phone,
    this.createdAt,
  });

  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    return BookingModel.fromJson(data);
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String?,
      eventId: json['eventId'] as String,
      paxCount: json['paxCount'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      createdAt: json['createdAt']?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'paxCount': paxCount,
      'name': name,
      'email': email,
      'phone': phone,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
