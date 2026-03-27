import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vinho/model/lead_model.dart';
import 'package:vinho/model/config_model.dart';

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

  Future<List<ConfigModel>> getConfigs(String lang) async {
    try {
      final snapshot = await config
          .where('lang', isEqualTo: lang)
          .where('status', isEqualTo: 'A')
          .orderBy('create_datetime')
          .get();
      return snapshot.docs.map((doc) => 
        ConfigModel.fromFirestore(doc)
      ).toList();
    } catch (e) {
      print('Get configs error: $e');
      return [];
    }
  }

  Future<String?> getPrivacyPolicy(String lang) async {
    try {
      final configs = await getConfigs(lang);
      final privacy = configs.firstWhere(
        (c) => c.key == 'PRIVACY_POLICY',
        orElse: () => null as ConfigModel,
      );
      return privacy?.content;
    } catch (e) {
      print('Get privacy policy error: $e');
      return null;
    }
  }
}

