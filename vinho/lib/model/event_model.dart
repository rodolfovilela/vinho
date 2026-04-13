import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  static EventModel fromFirestore(DocumentSnapshot doc) {
    final raw = doc.data();
    if (raw == null) throw Exception('Event data is null');

    final data = Map<String, dynamic>.from(raw as Map);

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
      timestamp: json['timestamp'] != null
          ? (json['timestamp'] as Timestamp?)?.toDate()
          : null,
      location: json['location'] as String?,
      address: json['address'] as String?,
      district: json['district'] as String?,
      municipality: json['municipality'] as String?,
      hostName: json['hostName'] as String?,
      sommelierName: json['sommelierName'] as String?,
      sommelierImgUrl: json['sommelierImgUrl'] as String?,
      order: (json['order'] as dynamic?)?.toInt(),
      paxPrice: (json['paxPrice'] as num?)?.toDouble(),
      bookedSeats: (json['bookedSeats'] as dynamic)?.toInt(),
      totalSeats: (json['totalSeats'] as dynamic)?.toInt(),
      minimumPaxRequired: (json['minimumPaxRequired'] as dynamic)?.toInt(),
      maxSeatsPerBooking: (json['maxSeatsPerBooking'] as dynamic)?.toInt(),
      deadlineForMinimumPax: json['deadlineForMinimumPax'] != null
          ? (json['deadlineForMinimumPax'] as Timestamp?)?.toDate()
          : null,
      adPriority: (json['adPriority'] as dynamic)?.toInt(),
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
      'timestamp': timestamp,
      'location': location,
      'address': address,
      'district': district,
      'municipality': municipality,
      'hostName': hostName,
      'sommelierName': sommelierName,
      'sommelierImgUrl': sommelierImgUrl,
      'order': order,
      'paxPrice': paxPrice,
      'bookedSeats': bookedSeats,
      'totalSeats': totalSeats,
      'minimumPaxRequired': minimumPaxRequired,
      'maxSeatsPerBooking': maxSeatsPerBooking,
      'deadlineForMinimumPax': deadlineForMinimumPax,
      'adPriority': adPriority,
    };
  }

  String? id;
  String? title;
  String? desc;
  String? detailedDesc;
  String? image;
  String? date;
  DateTime? timestamp;
  String? time;
  String? location;
  String? address;
  String? district;
  String? municipality;
  String? hostName;
  String? sommelierName;
  String? sommelierImgUrl;
  int? order;
  double? paxPrice;
  int? bookedSeats;
  int? totalSeats;
  int? minimumPaxRequired;
  DateTime? deadlineForMinimumPax;
  int? maxSeatsPerBooking;
  int? adPriority;

  EventModel({
    this.id,
    this.title,
    this.desc,
    this.detailedDesc,
    this.image,
    this.order,
    this.date,
    this.timestamp,
    this.location,
    this.address,
    this.district,
    this.municipality,
    this.hostName,
    this.sommelierName,
    this.sommelierImgUrl,
    this.time,
    this.paxPrice,
    this.bookedSeats,
    this.totalSeats,
    this.maxSeatsPerBooking,
    this.minimumPaxRequired,
    this.deadlineForMinimumPax,
    this.adPriority,
  });

  int get availableSeats {
    final total = totalSeats ?? 0;
    final booked = bookedSeats ?? 0;
    return total - booked;
  }

  bool get isSoldOut => availableSeats <= 0;
  bool get hasMaxSeatsPerBooking => maxSeatsPerBooking != null;
  bool get hasMinimumPaxRequired => minimumPaxRequired != null;
  bool get hasDeadlineForMinimumPax => deadlineForMinimumPax != null;
}
