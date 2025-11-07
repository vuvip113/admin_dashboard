import 'package:admin_dashboard/core/errors/exception.dart';
import 'package:admin_dashboard/core/errors/failures.dart';
import 'package:admin_dashboard/core/utils/constants/tydefs.dart';
import 'package:admin_dashboard/data/auth/datasources/auth_remote_data_source.dart';
import 'package:admin_dashboard/domain/auth/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  ResultFuture<void> login(String email, String password) async {
    try {
      await remoteDataSource.login(email, password);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
