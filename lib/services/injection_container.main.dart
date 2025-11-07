part of 'injection_container.dart';

final sl = GetIt.instance;
Future<void> init() async {
  //! ======================= Data sources =======================
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(FirebaseAuth.instance),
  );

  //! ======================= Repository =========================
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  //! ======================= Use Cases ==========================
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));
  sl.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(sl()));
}
