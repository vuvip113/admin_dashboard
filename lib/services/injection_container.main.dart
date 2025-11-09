part of 'injection_container.dart';

final sl = GetIt.instance;
Future<void> init() async {
  //! ======================= Data sources =======================
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(FirebaseAuth.instance),
  );
  sl.registerLazySingleton<CategoryDataSource>(() => CategoryDataSourceImpl());

  //! ======================= Repository =========================
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<CategoryRepo>(() => CategoryRepoImpl(sl()));

  //! ======================= Use Cases ==========================
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));
  sl.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(sl()));

  sl.registerLazySingleton<GetCategoryUsecase>(() => GetCategoryUsecase(sl()));
  sl.registerLazySingleton<AddCategoryUsecase>(() => AddCategoryUsecase(sl()));
}
