import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vinho/model/booking_model.dart';
import 'package:vinho/model/function_response_model.dart';

class FunctionsService {
  static final functions =
      FirebaseFunctions.instanceFor(region: 'europe-west1');

  static Future<FunctionResponseModel> bookSeats(
      String eventId, BookingModel booking) async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      final callable = functions.httpsCallable('bookSeats');
      final result =
          await callable.call(jsonDecode(jsonEncode(booking.toJson())));

      return FunctionResponseModel(
        success: result.data['success'] ?? false,
        messageKey: result.data['messageKey'] ?? '',
      );
    } on FirebaseFunctionsException catch (e) {
      print('Exception: $e.code, ${e.message}, ${e.details}');
      return FunctionResponseModel(
          success: false,
          messageKey: e.message ?? 'unknown-error',
          errorCode: e.code);
    }
  }

  /*  static Future<FunctionResponseModel> cancelBooking(
      String eventId, String bookingId) async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      final callable = functions.httpsCallable('cancelBooking');
      final result = await callable.call({
        'eventId': eventId,
        'bookingId': bookingId,
      });

      return FunctionResponseModel(
        success: result.data['success'] ?? false,
        messageKey: result.data['messageKey'] ?? '',
      );
    } on FirebaseFunctionsException catch (e) {
      print('Exception: $e.code, ${e.message}, ${e.details}');
      return FunctionResponseModel(
          success: false, messageKey: e.message ?? 'unknown-error', errorCode: e.code);
    }
  }
   */

  static Future<FunctionResponseModel> searchEvents(String location) async {
    try {
      final callable = functions.httpsCallable('searchEvents');
      final result = await callable.call({'location': location});

      return FunctionResponseModel.fromMap(result
              .data) /* (
        success: result.data['success'] ?? false,
        messageKey: result.data['messageKey'] ?? '',
        entitieIds: List<String>.from(result.data['entities']?.map((e) => e['id']) ?? []),
      ) */
          ;
    } on FirebaseFunctionsException catch (e) {
      print('Exception: $e.code, ${e.message}, ${e.details}');
      return FunctionResponseModel(
          success: false,
          messageKey: e.message ?? 'unknown-error',
          errorCode: e.code,
          entitieIds: []);
    }
  }
}
