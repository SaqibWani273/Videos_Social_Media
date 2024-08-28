// ignore_for_file: public_member_api_docs, sort_constructors_first
class CustomException implements Exception {
  final String message;
  CustomException({required this.message});
}

class ServerException implements Exception {
  final String message;
  final int? statusCode;
  ServerException({
    required this.message,
    this.statusCode,
  });
}
