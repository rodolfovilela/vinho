import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vinho/model/config_model.dart';
import 'package:vinho/model/event_model.dart';
import 'package:vinho/model/lead_model.dart';
import 'package:vinho/services/location.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get events => _db.collection('events');

  CollectionReference get leads => _db.collection('leads');

  CollectionReference get config => _db.collection('config');

  static CollectionReference get exceptions => _db.collection('exceptions');

  Stream<QuerySnapshot> getEventsStream(String lang) => events
      .where("status", isEqualTo: "A")
      .where("timestamp", isGreaterThanOrEqualTo: Timestamp.now())
      .orderBy('date')
      .snapshots();

  Future<DocumentSnapshot?> getEvent(String id) async {
    try {
      return await events.doc(id).get();
    } catch (e) {
      exceptionLog("Get event", {'id': id}, e);
      return null;
    }
  }

  Future<DocumentReference> addEvent(Map<String, dynamic> data) async {
    try {
      return await events.add(data);
    } catch (e) {
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
      return snapshot.docs
          .map((doc) => LeadModel.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      exceptionLog("Get leads", {'lang': lang}, e);
      return [];
    }
  }

  Future<DocumentReference> addLead(Map<String, dynamic> data) async {
    try {
      // data['createdAt'] = FieldValue.serverTimestamp();
      return await leads.add(data);
    } catch (e) {
      exceptionLog("Add lead", {}, e);
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
      return snapshot.docs
          .map((doc) => ConfigModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      exceptionLog("Get configs", {'lang': lang, 'key': key}, e);
      return [];
    }
  }

  Future<ConfigModel?> getPrivacyPolicy(String lang) async {
    try {
      final privacy = await getConfigs(lang, 'PRIVACY_POLICY');

      return privacy.firstWhere((config) => config.key == 'PRIVACY_POLICY',
          orElse: () => ConfigModel());
    } catch (e) {
      exceptionLog("Get privacy policy", {}, e);
      return null;
    }
  }

  Future<List<EventModel>> searchEvents(String loc) async {
    try {
      final String location =
          LocationSearchService.normalize(loc).toUpperCase();

      if (location.trim().isNotEmpty) {
        final snapshot = await events
            .where("timestamp", isGreaterThanOrEqualTo: Timestamp.now())
            .where("locationKeys", arrayContains: location)
            .get();

        final List<EventModel> ret = snapshot.docs
            .map((doc) =>
                EventModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList();

        if (ret.isEmpty && location.length >= 3) {
          logSearchResults(location.toUpperCase());
        }

        return ret;
      } else {
        return [];
      }
    } catch (err) {
      exceptionLog("Failed to search query", {'loc': loc}, err);
      return [];
    }
  }

  void logSearchResults(String location) async {
    try {
      final logActive = (await (config.doc('search_analytics').get()))
              .get('active') as bool ||
          false;

      if (logActive) {
        final searchLogsRef = _db.collection("searchLogs");

        final now = Timestamp.now();
        final log = searchLogsRef.doc(location);

        log.set({
          'lastSearchTimestamp': now,
          'count': FieldValue.increment(1),
          //'timestamps': FieldValue.arrayUnion([now])
        }, SetOptions(merge: true));

        log.collection('timestamps').add({'timestamp': now});
      }
    } catch (err) {
      print("ERR:$err");
      exceptionLog("Failed to log search query", {'location': location}, err);
    }
  }

  static void exceptionLog(
      String where, Map<String, String> params, dynamic err) {
    exceptions.add({'where': where, 'params': params, 'err': err});
  }
}
