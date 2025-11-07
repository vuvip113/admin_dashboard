import 'package:admin_dashboard/data/auth/datasources/auth_remote_data_source.dart';
import 'package:admin_dashboard/data/auth/repositories/auth_repository_impl.dart';
import 'package:admin_dashboard/domain/auth/repositories/auth_repository.dart';
import 'package:admin_dashboard/domain/auth/usecases/login_usecase.dart';
import 'package:admin_dashboard/domain/auth/usecases/logout_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
part 'injection_container.main.dart';
