import 'package:dio/dio.dart';
import 'error_model.dart';

/// ===============================
/// Base Exception
/// ===============================

abstract class AppException implements Exception {
  final ErrorModel errorModel;

  AppException(this.errorModel);

  @override
  String toString() => errorModel.errorMessage;
}

/// ===============================
/// Server Exception
/// ===============================

class ServerException extends AppException {
  ServerException(super.errorModel);
}

/// ===============================
/// Cache Exception
/// ===============================

class CacheException implements Exception {
  final String errorMessage;

  CacheException({required this.errorMessage});
}

/// ===============================
/// Network Exceptions
/// ===============================

class BadCertificateException extends ServerException {
  BadCertificateException(super.errorModel);
}

class ConnectionTimeoutException extends ServerException {
  ConnectionTimeoutException(super.errorModel);
}

class ReceiveTimeoutException extends ServerException {
  ReceiveTimeoutException(super.errorModel);
}

class SendTimeoutException extends ServerException {
  SendTimeoutException(super.errorModel);
}

class ConnectionErrorException extends ServerException {
  ConnectionErrorException(super.errorModel);
}

class CancelException extends ServerException {
  CancelException(super.errorModel);
}

class UnknownException extends ServerException {
  UnknownException(super.errorModel);
}

/// ===============================
/// HTTP Exceptions
/// ===============================

class BadResponseException extends ServerException {
  BadResponseException(super.errorModel);
}

class UnauthorizedException extends ServerException {
  UnauthorizedException(super.errorModel);
}

class ForbiddenException extends ServerException {
  ForbiddenException(super.errorModel);
}

class NotFoundException extends ServerException {
  NotFoundException(super.errorModel);
}

class ConflictException extends ServerException {
  ConflictException(super.errorModel);
}

/// ===============================
/// Helper
/// ===============================

ErrorModel _getErrorModel(DioException e) {
  final response = e.response;

  if (response != null && response.data is Map<String, dynamic>) {
    return ErrorModel.fromJson(response.data);
  } else if (response != null && response.data is String) {
    return ErrorModel(
      status: response.statusCode ?? 400,
      errorMessage: response.data,
    );
  }

  print(e.error);

  return ErrorModel(
    status: response?.statusCode ?? 500,
    errorMessage: response?.statusMessage ?? e.message ?? "Unexpected Error",
  );
}

/// ===============================
/// Dio Exception Handler
/// ===============================

Never handleDioException(DioException e) {
  final error = _getErrorModel(e);

  switch (e.type) {
    case DioExceptionType.connectionError:
      throw ConnectionErrorException(error);

    case DioExceptionType.connectionTimeout:
      throw ConnectionTimeoutException(error);

    case DioExceptionType.receiveTimeout:
      throw ReceiveTimeoutException(error);

    case DioExceptionType.sendTimeout:
      throw SendTimeoutException(error);

    case DioExceptionType.badCertificate:
      throw BadCertificateException(error);

    case DioExceptionType.cancel:
      throw CancelException(error);

    case DioExceptionType.badResponse:
      switch (error.status) {
        case 400:
          throw BadResponseException(error);

        case 401:
          throw UnauthorizedException(error);

        case 403:
          throw ForbiddenException(error);

        case 404:
          throw NotFoundException(error);

        case 409:
          throw ConflictException(error);

        case 500:
        case 502:
        case 503:
        case 504:
          throw ServerException(error);

        default:
          throw ServerException(error);
      }

    default:
      throw UnknownException(error);
  }
}
