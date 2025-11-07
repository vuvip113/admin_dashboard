import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:admin_dashboard/domain/auth/usecases/logout_usecase.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final LogoutUseCase logoutUseCase;

  LogoutCubit(this.logoutUseCase) : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutLoading());
    final result = await logoutUseCase();
    result.fold(
      (failure) => emit(LogoutFailure(failure.message)),
      (_) => emit(LogoutSuccess()),
    );
  }
}
