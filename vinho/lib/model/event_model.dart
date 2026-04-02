import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  static EventModel fromFirestore(DocumentSnapshot doc) {
    final raw = doc.data() as Map<String, dynamic>;

    final data = Map<String, dynamic>.from(raw);

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
      order: (json['order'] as dynamic?)?.toInt(),
      paxPrice: (json['paxPrice'] as num?)?.toDouble(),
      bookedSeats: (json['bookedSeats'] as dynamic)?.toInt(),
      totalSeats: (json['totalSeats'] as dynamic)?.toInt(),
      minimumPaxRequired: (json['minimumPaxRequired'] as dynamic)?.toInt(),
      maxSeatsPerBooking: (json['maxSeatsPerBooking'] as dynamic)?.toInt(),
      deadlineForMinimumPax:
          (json['deadlineForMinimumPax'] as Timestamp?)?.toDate(),
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
      'bookedSeats': bookedSeats,
      'totalSeats': totalSeats,
      'minimumPaxRequired': minimumPaxRequired,
      'maxSeatsPerBooking': maxSeatsPerBooking,
      'deadlineForMinimumPax': deadlineForMinimumPax,
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
  int? bookedSeats;
  int? totalSeats;
  int? minimumPaxRequired;
  DateTime? deadlineForMinimumPax;
  int? maxSeatsPerBooking;

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
    this.bookedSeats,
    this.totalSeats,
    this.maxSeatsPerBooking,
    this.minimumPaxRequired,
    this.deadlineForMinimumPax,
  });

  int get availableSeats {
    if (totalSeats == null) return 0;
    return totalSeats! - bookedSeats!;
  }
  
  bool get isFullyBooked => availableSeats <= 0;
  bool get hasMaxSeatsPerBooking => maxSeatsPerBooking != null;
  bool get hasMinimumPaxRequired => minimumPaxRequired != null;
  bool get hasDeadlineForMinimumPax => deadlineForMinimumPax != null;
}
