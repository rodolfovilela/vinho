import 'package:vinho/services/firestore_service.dart';
import 'package:vinho/mock/mock_data.dart';
import 'package:vinho/model/event_model.dart';

class SeedService {
  static Future<void> seedEvents() async {
    final firestore = FirestoreService();
    
    // Clear existing events
    final snapshot = await firestore.events.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    // Add mocked events
    for (var event in mockedEvents) {
      await firestore.events.add(event.toJson());
    }

    print('✅ Seeded ${mockedEvents.length} events to Firestore');
  }

  static Future<void> disableEvents() async {
    final firestore = FirestoreService();
    
    // Clear existing events
    final snapshot = await firestore.events.get();
    for (var doc in snapshot.docs) {
      await doc.reference.update({"status": "I"});
    }

    print('✅ Disabled ${snapshot.docs.length} events in Firestore');
  }
}

