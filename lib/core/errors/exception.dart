import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception {
  final String massage;
  final int statusCode;

  const ServerException({required this.massage, required this.statusCode});

  @override
  List<Object> get props => [massage, statusCode];
}

class CacheException extends Equatable implements Exception {
  final String message;

  const CacheException(String errorMessage, {required this.message});

  @override
  List<Object> get props => [message];
}
