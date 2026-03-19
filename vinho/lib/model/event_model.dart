import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  static EventModel fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    return EventModel.fromJson(data);
  }

  static EventModel fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      desc: json['desc'] as String?,
      detailedDesc: json['detailedDesc'] as String?,
      image: json['image'] as String?,
      date: json['date'] as String?,
      time: json['time'] as String?,
      location: json['location'] as String?,
      address: json['address'] as String?,
      region: json['region'] as String?,
      hostName: json['hostName'] as String?,
      sommelierName: json['sommelierName'] as String?,
      sommelierImgUrl: json['sommelierImgUrl'] as String?,
      order: json['order'] as int?,
      paxPrice: (json['paxPrice'] as num?)?.toDouble(),
      availableSeats: json['availableSeats'] as int?,
      totalSeats: json['totalSeats'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'detailedDesc': detailedDesc,
      'image': image,
      'date': date,
      'time': time,
      'location': location,
      'address': address,
      'region': region,
      'hostName': hostName,
      'sommelierName': sommelierName,
      'sommelierImgUrl': sommelierImgUrl,
      'order': order,
      'paxPrice': paxPrice,
      'availableSeats': availableSeats,
      'totalSeats': totalSeats,
    };
  }

  String? id;
  String? title;
  String? desc;
  String? detailedDesc;
  String? image;
  String? date;
  String? time;
  String? location;
  String? address;
  String? region;
  String? hostName;
  String? sommelierName;
  String? sommelierImgUrl;
  int? order;
  double? paxPrice;
  int? availableSeats;
  int? totalSeats;

  EventModel({
    this.id,
    this.title,
    this.desc,
    this.detailedDesc,
    this.image,
    this.order,
    this.date,
    this.location,
    this.address,
    this.region,
    this.hostName,
    this.sommelierName,
    this.sommelierImgUrl,
    this.time,
    this.paxPrice,
    this.availableSeats,
    this.totalSeats,
  });
}

