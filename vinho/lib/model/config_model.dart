import 'package:cloud_firestore/cloud_firestore.dart';

class ConfigModel {
  final String? id;
  final String? key;
  final String? content;
  final String? status;
  final String? lang;
  final DateTime? createDatetime;

  ConfigModel({
    this.id,
    this.key,
    this.content,
    this.status,
    this.lang,
    this.createDatetime,
  });

  factory ConfigModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    return ConfigModel.fromJson(data);
  }

  factory ConfigModel.fromJson(Map<String, dynamic> json) {
    return ConfigModel(
      id: json['id'] as String?,
      key: json['key'] as String?,
      content: json['content'] as String?,
      status: json['status'] as String?,
      lang: json['lang'] as String?,
      createDatetime: json['create_datetime']?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'content': content,
      'status': status,
      'lang': lang,
      'create_datetime': createDatetime,
    };
  }
}
