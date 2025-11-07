import 'package:admin_dashboard/common/bloc/navigator/navigation_cubit.dart';
import 'package:admin_dashboard/core/configs/theme/app_theme.dart';
import 'package:admin_dashboard/firebase_options.dart';
import 'package:admin_dashboard/presentation/login/pages/login_page.dart';
import 'package:admin_dashboard/services/injection_container.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationCubit(),
      child: MaterialApp(
        theme: AppTheme.appTheme,
        debugShowCheckedModeBanner: false,
        title: 'Admin Dashboard',
        home: LoginPage(),
      ),
    );
  }
}
