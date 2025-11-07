import 'package:admin_dashboard/core/usecase/usecase.dart';
import 'package:admin_dashboard/core/utils/constants/tydefs.dart';
import 'package:admin_dashboard/domain/auth/repositories/auth_repository.dart';

/// 🧩 UseCase đăng xuất người dùng
class LogoutUseCase implements UsecaseWithoutParams<void> {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  ResultFuture<void> call() async {
    return await repository.logout();
  }
}
