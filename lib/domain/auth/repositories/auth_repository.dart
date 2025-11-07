import 'package:admin_dashboard/core/utils/constants/tydefs.dart';

abstract class AuthRepository {
  ResultFuture<void> login(String email, String password);
  ResultFuture<void> logout();
}
