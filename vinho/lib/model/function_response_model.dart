class FunctionResponseModel {
  final bool success;
  final String messageKey;
  final String errorCode;
  final List<String> entitieIds;

  FunctionResponseModel(
      {required this.success,
      required this.messageKey,
      this.errorCode = '',
      this.entitieIds = const []});

  factory FunctionResponseModel.fromMap(Map<String, dynamic> map) {
    return FunctionResponseModel(
      success: map['success'] ?? false,
      messageKey: map['messageKey'] ?? '',
      errorCode: map['errorCode'] ?? '',
      entitieIds: List<String>.from(map['entities']?.map((e) => e['id']) ?? []),
    );
  }
}
