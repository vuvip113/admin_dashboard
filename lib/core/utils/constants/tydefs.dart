import 'package:admin_dashboard/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef ResultVoid = ResultFuture<void>;
typedef DataMap = Map<String, dynamic>;
