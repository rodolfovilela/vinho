import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vinho/model/lead_model.dart';
import 'package:vinho/model/config_model.dart';
import 'package:vinho/model/booking_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get events => _db.collection('events');
 
  CollectionReference get leads => _db.collection('leads');

  CollectionReference get config => _db.collection('config');

Stream<QuerySnapshot> getEventsStream(String lang) => events/* .where("lang", isEqualTo: lang) */.where("status", isEqualTo: "A").orderBy('date').snapshots();

  Future<DocumentSnapshot?> getEvent(String id) async {
    try {
      return await events.doc(id).get();
    } catch (e) {
      print('Get event error: $e');
      return null;
    }
  }

  Future<DocumentReference> addEvent(Map<String, dynamic> data) async {
    try {
      return await events.add(data);
    } catch (e) {
      print('Add event error: $e');
      rethrow;
    }
  }

  Future<List<LeadModel>> getLeads(String lang) async {
    try {
      final snapshot = await leads
          .where('lang', isEqualTo: lang)
          .where('status', isEqualTo: 'A')
          .orderBy('order')
          .get();
      return snapshot.docs.map((doc) => 
        LeadModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id)
      ).toList();
    } catch (e) {
      print('Get leads error: $e');
      return [];
    }
  }

  Future<DocumentReference> addLead(Map<String, dynamic> data) async {
    try {
     // data['createdAt'] = FieldValue.serverTimestamp();
      return await leads.add(data);
    } catch (e) {
      print('Add lead error: $e');
      rethrow;
    }
  }

  Future<List<ConfigModel>> getConfigs(String lang, String key) async {
    try {
      final snapshot = await config
          .where('lang', isEqualTo: lang)
          .where('status', isEqualTo: 'A')
          .where('key', isEqualTo: key)
         // .orderBy('createDatetime')
          .get();
      return snapshot.docs.map((doc) => 
        ConfigModel.fromFirestore(doc)
      ).toList();
    } catch (e) {
      print('Get configs error: $e');
      return [];
    }
  }

  Future<ConfigModel?> getPrivacyPolicy(String lang) async {
    try {
      final privacy = await getConfigs(lang, 'PRIVACY_POLICY');
      
      return privacy.firstWhere((config) => config.key == 'PRIVACY_POLICY', orElse: () => ConfigModel());
    } catch (e) {
      print('Get privacy policy error: $e');
      return null;
    }
  }

  Future<DocumentReference> addBooking(String eventId, BookingModel booking) async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      return await events.doc(eventId).collection('bookings').add(booking.toJson());
    } catch (e) {
      print('Add booking error: $e');
      rethrow;
    }
  }
}
