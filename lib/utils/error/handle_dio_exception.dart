import 'package:dio/dio.dart';
import 'package:persist_ventures/utils/app_logger.dart';

String handleDioException(DioExceptionType exType) {
  AppLogger.logMessage("dio Error -> $exType");
  String errorMessage = "";
  switch (exType) {
    case DioExceptionType.cancel:
      errorMessage = "Request to API server was cancelled";
      break;
    case DioExceptionType.connectionTimeout:
      errorMessage = "Connection timeout with API server";
      break;
    case DioExceptionType.receiveTimeout:
      errorMessage = "Receive timeout in connection with API server";
      break;
    case DioExceptionType.badResponse:
    default:
      errorMessage = "Unknown Error";
  }
  return errorMessage;
}
