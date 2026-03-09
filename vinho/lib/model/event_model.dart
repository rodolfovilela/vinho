class EventModel {
  int? id;
  String? title;
  String? desc;
  String? image;
  String? date;
  String? time;
  String? location;
  String? region;
  int? order;
  double? paxPrice;
  int ? availableSeats;

  EventModel({
    this.id,
    this.title,
    this.desc,
    this.image,
    this.order,
    this.date,
    this.location,
    this.region,
    this.time,
    this.paxPrice,
    this.availableSeats,
  });
}
