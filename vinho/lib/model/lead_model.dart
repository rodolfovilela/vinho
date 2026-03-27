import 'package:flutter/material.dart';

class LeadModel {
  final String id;
  final String title;
  final String shortDescription;
  final String description;

  final String? iconCode;
  final String? imageUrl;
  final String? route;
  final DateTime? createdAt;
  final String? status;

  const LeadModel({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.description,
    this.iconCode,
    this.imageUrl,
    this.route,
    this.createdAt,
    this.status,
  });

  IconData? get icon => iconCode != null
      ? IconData(int.parse(iconCode!), fontFamily: 'MaterialIcons')
      : null;

  factory LeadModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return LeadModel(
      id: docId,
      title: data['title'] ?? '',
      shortDescription: data['shortDescription'] ?? '',
      description: data['description'] ?? '',
      iconCode: data['iconCode'],
      imageUrl: data['imageUrl'],
      route: data['route'],
      createdAt: data['createdAt']?.toDate(),
      status: data['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'shortDescription': shortDescription,
        'description': description,
        'iconCode': iconCode,
        'imageUrl': imageUrl,
        'route': route,
        'createdAt': createdAt,
        'status': status,
      };
}
