import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vinho/model/booking_model.dart';

class FunctionsService {
  static final functions =
      FirebaseFunctions.instanceFor(region: 'europe-west1');

  static Future<bool> bookSeats(String eventId, BookingModel booking) async {
    try {
      print('booking.seats runtimeType: ${booking.seats.runtimeType}');
      print('booking.phone runtimeType: ${booking.phone.runtimeType}');
      print('booking.name runtimeType: ${booking.name.runtimeType}');

      print('Attempting to sign in anonymously...');
      await FirebaseAuth.instance.signInAnonymously();
      print(
          '✅ Signed in anonymously with UID: ${FirebaseAuth.instance.currentUser?.uid}');
      final callable = functions.httpsCallable('bookSeats');
      print('Calling Cloud Function with data: { name: ${booking.name} }');
      final result = await callable.call(jsonDecode(jsonEncode(booking.toJson())));
      print('Cloud Function result.data type: ${result.data.runtimeType}');
      // Force recursive parse for nested Int64 on web - touch all values

      return true;
    } catch (e, stackTrace) {
      print('Exception: $e'); // prints the exception message
      print('StackTrace: $stackTrace'); // prints full stack trace
      return false;
    }
  }
}
