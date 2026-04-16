enum LocationType { district, municipality }

class LocationResult {
  final String label;
  final String districtCode;
  final LocationType type;

  

  LocationResult({
    required this.label,
    required this.districtCode,
    required this.type,
  });

  String get uniqueKey => label;
/* 
  String get displayLabel {
    return type == LocationType.district
        ? "$label (Distrito)"
        : "$label, ${districtCode}";
  } */
/* 
  static String _formatDistrict(String code) {
    return code[0] + code.substring(1).toLowerCase();
  } */
}
