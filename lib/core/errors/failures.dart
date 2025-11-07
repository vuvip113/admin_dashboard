import 'package:admin_dashboard/core/errors/exception.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure({required this.message, required this.statusCode});

  final String message;
  final dynamic statusCode;

  String get errorMessage => '$statusCode Error : $message';

  @override
  List<Object> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, required super.statusCode});

  ServerFailure.fromException(ServerException exception)
    : this(message: exception.massage, statusCode: exception.statusCode);
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message}) : super(statusCode: 3);

  CacheFailure.fromexception(CacheException e) : this(message: e.message);
}
