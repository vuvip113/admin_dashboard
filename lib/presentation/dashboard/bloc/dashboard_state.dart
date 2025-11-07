part of 'dashboard_cubit.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final int totalOrders;
  final int totalUsers;
  final int todayRevenue;

  const DashboardLoaded({
    required this.totalOrders,
    required this.totalUsers,
    required this.todayRevenue,
  });
}
