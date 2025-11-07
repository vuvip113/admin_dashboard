import 'package:admin_dashboard/core/usecase/usecase.dart';
import 'package:admin_dashboard/core/utils/constants/tydefs.dart';
import 'package:admin_dashboard/domain/auth/repositories/auth_repository.dart';

class LoginUseCase implements UsecaseWithParams<void, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  ResultFuture<void> call(LoginParams user) async {
    return await repository.login(user.email, user.password);
  }
}

class LoginParams {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});
}
