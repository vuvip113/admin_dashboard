import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:admin_dashboard/domain/auth/usecases/login_usecase.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      final result = await loginUseCase(
        LoginParams(email: email, password: password),
      );

      result.fold(
        (failure) => emit(LoginFailure(failure.message)),
        (_) => emit(LoginSuccess()), // vì loginUseCase trả về void
      );
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
