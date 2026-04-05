import 'package:vinho/model/booking_model.dart';
import 'package:vinho/model/event_model.dart';
import 'package:vinho/model/function_response_model.dart';

class BookingSummaryModel {
  final BookingModel booking;
  final EventModel event;
  FunctionResponseModel? response;

  BookingSummaryModel({
    required this.booking,
    required this.event,
    this.response,
  });
}
