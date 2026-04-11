class FirestoreParser {
  /* static int toInt(dynamic value) {
    if (value == null) return 0;

    if (value is int) return value;
    if (value is num) return value.toInt();

    // 🔥 This is what fixes JSInt64 on web
    final str = value.toString();

    return int.tryParse(str) ?? 0;
  } */

 static int? toInt(dynamic value) {
    if (value == null) return null;

    if (value is int) return value;
    if (value is double) return value.toInt();

    // 🔥 CRÍTICO: suporta web + firestore
    try {
      return int.parse(value.toString());
    } catch (_) {
      return null;
    }
  }

  static double toDouble(dynamic value) {
    if (value == null) return 0.0;

    if (value is double) return value;
    if (value is num) return value.toDouble();

    return double.tryParse(value.toString()) ?? 0.0;
  }

  static String toStringSafe(dynamic value) {
    return value?.toString() ?? '';
  }

  static bool toBool(dynamic value) {
    if (value is bool) return value;
    return value.toString().toLowerCase() == 'true';
  }
}
