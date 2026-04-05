class FunctionResponseModel {
  final bool success;
  final String messageKey;
  final String errorCode;

  FunctionResponseModel({required this.success, required this.messageKey, this.errorCode = ''});

  factory FunctionResponseModel.fromMap(Map<String, dynamic> map) {
    return FunctionResponseModel(
      success: map['success'] ?? false,
      messageKey: map['messageKey'] ?? '',
      errorCode: map['errorCode'] ?? '',
    );
  }
}
