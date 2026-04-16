import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vinho/model/location_result_model.dart';

class LocationSearchService {
  LocationSearchService();

  static late Map<String, List<String>> locations;
  static late List<LocationResult> locationsList;
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
    locationsList = [];

    return data.map((key, value) {
      locationsList.add(LocationResult(
          label: formatDistrict(key),
          districtCode: formatDistrict(key),
          type: LocationType.district));

      for (var mun in List<String>.from(value)) {
        locationsList.add(LocationResult(
            label: mun,
            districtCode: formatDistrict(key),
            type: LocationType.municipality));
      }
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

    final q = normalize(query);

    final results = <LocationResult>[];

    final locations = LocationSearchService.locations;
    for (final entry in locations.entries) {
      final district = entry.key;
      final municipalities = entry.value;

      if (normalize(district).contains(q)) {
        results.add(LocationResult(
          label: district,
          districtCode: district,
          type: LocationType.district,
        ));
      }

      for (final m in municipalities) {
        if (normalize(m).contains(q)) {
          results.add(LocationResult(
            label: m,
            districtCode: district,
            type: LocationType.municipality,
          ));
        }
      }
    }

    results.sort((a, b) {
      if (a.type != b.type) {
        return a.type == LocationType.municipality ? -1 : 1;
      }
      return a.label.compareTo(b.label);
    });

    return results.take(10).toList();
  }

  static List<LocationResult> getSuggestions(
    String input,
    /* 
    List<LocationResult> allLocations, */
  ) {
    final query = normalize(input);

    if (query.length < 3) return [];

    final results = LocationSearchService.locationsList
        .map((loc) {
          final normalizedName = normalize(loc.label);

          int score = 0;

          if (normalizedName == query) {
            score += 100;
          }

          if (normalizedName.startsWith(query)) {
            score += 80;
          }

          if (normalizedName.contains(query)) {
            score += 50;
          }

          final distance = levenshtein(normalizedName, query);
          if (distance <= 2) {
            score += (30 - distance * 10); // quanto menor a distância, melhor
          }

          return {
            'location': loc,
            'score': score,
          };
        })
        .where((e) => e['score'] as int > 0)
        .toList();

    results.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));
    
    final seen = <String>{};
    
    return results
        .where((r) {
          final lr = r['location'] as LocationResult;
          final key = lr.label;
          
          if (seen.contains(key)) return false;
          seen.add(key);
          return true;
        })
        .map((e) => e['location'] as LocationResult)
        .take(3)
        .toSet()
        .toList();
  }

  static int levenshtein(String s, String t) {
    final m = s.length;
    final n = t.length;

    List<List<int>> dp = List.generate(
      m + 1,
      (_) => List.generate(n + 1, (_) => 0),
    );

    for (int i = 0; i <= m; i++) dp[i][0] = i;
    for (int j = 0; j <= n; j++) dp[0][j] = j;

    for (int i = 1; i <= m; i++) {
      for (int j = 1; j <= n; j++) {
        if (s[i - 1] == t[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1];
        } else {
          dp[i][j] = 1 +
              [dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1]]
                  .reduce((a, b) => a < b ? a : b);
        }
      }
    }

    return dp[m][n];
  }

  static String normalize(String input) {
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
