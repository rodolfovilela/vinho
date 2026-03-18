class EventModel {
  int? id;
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
    this.time,
    this.paxPrice,
    this.availableSeats,
    this.totalSeats,
  });
}
