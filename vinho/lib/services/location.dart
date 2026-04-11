import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vinho/model/location_result_model.dart';

class LocationSearchService {
  LocationSearchService();

  static late Map<String, List<String>> locations;
  /*  static Future<Map<String, List<String>>> loadLocations() async {
    final doc = await FirebaseFirestore.instance
        .collection('config')
        .doc('locations')
        .get();

    if (!doc.exists || !doc.data()!.containsKey('districts')) {
      print('⚠️ No locations config found in Firestore');
      return {};
    }

    final data = doc.data()!;
    final districts = data['districts'] as Map<String, dynamic>;

    return districts.map((key, value) {
      return MapEntry(
        key,
        List<String>.from(value),
      );
    });
  }

  static Future<Map<String, List<String>>> loadLocations1() async {
    final doc = await FirebaseFirestore.instance
        .collection('config')
        .doc('locations')
        .get();

    if (!doc.exists) {
      print('⚠️ No locations config found in Firestore');
      return {};
    }

    final data = doc.data() as Map<String, dynamic>;

    return data.map((key, value) {
      return MapEntry(
        key,
        List<String>.from(value),
      );
    });
  }
 */
  static Future<Map<String, List<String>>> loadLocations() async {
    final doc = await FirebaseFirestore.instance
        .collection('config')
        .doc('locations')
        .get();

    final data = doc.data() as Map<String, dynamic>;

    return data.map((key, value) {
      print(formatDistrict(key));
      return MapEntry(
        formatDistrict(key),
        List<String>.from(value),
      );
    });
  }

  static formatDistrict(String code) {
    return code
        .toLowerCase()
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) =>
            word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  List<LocationResult> search(String query) {
    if (query.isEmpty) return [];

    final q = _normalize(query);

    final results = <LocationResult>[];

    final locations = LocationSearchService.locations;
    for (final entry in locations.entries) {
      final district = entry.key;
      final municipalities = entry.value;

      //final districtName = _formatDistrict(district);

      // 🔹 match distrito
      if (_normalize(district).contains(q)) {
        results.add(LocationResult(
          label: district,
          districtCode: district,
          type: LocationType.district,
        ));
      }

      // 🔹 match municípios
      for (final m in municipalities) {
        if (_normalize(m).contains(q)) {
          results.add(LocationResult(
            label: m,
            districtCode: district,
            type: LocationType.municipality,
          ));
        }
      }
    }

    // 🔥 ordenar: municípios primeiro (melhor UX)
    results.sort((a, b) {
      if (a.type != b.type) {
        return a.type == LocationType.municipality ? -1 : 1;
      }
      return a.label.compareTo(b.label);
    });

    return results.take(10).toList();
  }

  String _normalize(String input) {
    return input
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('à', 'a')
        .replaceAll('ã', 'a')
        .replaceAll('â', 'a')
        .replaceAll('é', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('õ', 'o')
        .replaceAll('ô', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ç', 'c');
  }

  /* String _formatDistrict(String code) {
    return code[0] + code.substring(1).toLowerCase();
  } */
}
