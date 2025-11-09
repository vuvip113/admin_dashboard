part of 'pick_mage_cate_cubit.dart';

sealed class PickMageCateState extends Equatable {
  const PickMageCateState();

  @override
  List<Object> get props => [];
}

final class PickMageCateInitial extends PickMageCateState {}

final class PickMageCateLoading extends PickMageCateState {}

final class PickMageCateSuccess extends PickMageCateState {
  final File imageFile;
  const PickMageCateSuccess({required this.imageFile});
}

final class PickMageCateError extends PickMageCateState {
  final String message;
  const PickMageCateError({required this.message});
}
