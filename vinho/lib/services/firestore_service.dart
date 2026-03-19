import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Events collection
  CollectionReference get events => _db.collection('events');

  // Leads collection  
  CollectionReference get leads => _db.collection('leads');

  // Get all events
  Stream<QuerySnapshot> getEventsStream() => events.orderBy('date').snapshots();

  // Get single event
  Future<DocumentSnapshot?> getEvent(String id) async {
    try {
      return await events.doc(id).get();
    } catch (e) {
      print('Get event error: $e');
      return null;
    }
  }

  // Add event
  Future<DocumentReference> addEvent(Map<String, dynamic> data) async {
    try {
      return await events.add(data);
    } catch (e) {
      print('Add event error: $e');
      rethrow;
    }
  }

  // Get leads stream
  Stream<QuerySnapshot> getLeadsStream() => leads.orderBy('createdAt', descending: true).snapshots();

  // Add lead
  Future<DocumentReference> addLead(Map<String, dynamic> data) async {
    try {
      data['createdAt'] = FieldValue.serverTimestamp();
      return await leads.add(data);
    } catch (e) {
      print('Add lead error: $e');
      rethrow;
    }
  }
}

