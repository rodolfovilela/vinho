import 'package:vinho/model/booking_model.dart';
import 'package:vinho/model/event_model.dart';

class BookingSummaryModel {
  final BookingModel booking;
  final EventModel event;
  final bool isSuccessful;
  final String? extraMessage;

  BookingSummaryModel({
    required this.booking,
    required this.event,
    required this.isSuccessful,
    this.extraMessage,
  });
}
