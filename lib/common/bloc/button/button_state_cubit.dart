import 'package:admin_dashboard/common/bloc/button/button_state.dart';
import 'package:admin_dashboard/core/usecase/usecase.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonStateCubit extends Cubit<ButtonState> {
  ButtonStateCubit() : super(ButtonInitialState());

  /// Gọi usecase có params
  Future<void> executeUsecase<Type, Params>(
    UsecaseWithParams<Type, Params> usecase,
    Params params,
  ) async {
    emit(ButtonLoadingState());
    final result = await usecase(params);
    result.fold(
      (failure) => emit(ButtonFailureState(errorMessage: failure.toString())),
      (data) => emit(ButtonSuccessState()),
    );
  }

  /// Gọi usecase không có params
  Future<void> executeWithoutParams<Type>(
    UsecaseWithoutParams<Type> usecase,
  ) async {
    emit(ButtonLoadingState());

    final result = await usecase();
    result.fold(
      (failure) => emit(ButtonFailureState(errorMessage: failure.toString())),
      (data) => emit(ButtonSuccessState()),
    );
  }

  /// Reset về trạng thái ban đầu
  void reset() {
    emit(ButtonInitialState());
  }

  void showLoading() => emit(ButtonLoadingState());
}
