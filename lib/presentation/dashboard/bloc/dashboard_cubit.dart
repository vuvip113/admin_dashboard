import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());

 Future<void> loadDashboardData() async {
    emit(DashboardLoading());

    // Giả lập gọi API
    await Future.delayed(const Duration(seconds: 2));

    emit(const DashboardLoaded(
      totalOrders: 1250,
      totalUsers: 520,
      todayRevenue: 3420,
    ));
  }
}
