import 'package:admin_dashboard/presentation/login/bloc/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_dashboard/domain/auth/usecases/login_usecase.dart';
import 'package:admin_dashboard/data/auth/repositories/auth_repository_impl.dart';
import 'package:admin_dashboard/data/auth/datasources/auth_remote_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:admin_dashboard/presentation/dashboard/pages/dashboard_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    final loginUseCase = LoginUseCase(
      AuthRepositoryImpl(AuthRemoteDataSourceImpl(FirebaseAuth.instance)),
    );

    return Scaffold(
      body: Center(
        child: BlocProvider(
          create: (_) => LoginCubit(loginUseCase),
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const DashboardPage()),
                );
              } else if (state is LoginFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              final cubit = context.read<LoginCubit>();
              return Container(
                width: 400,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Admin Login",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Mật khẩu",
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: state is LoginLoading
                            ? null
                            : () {
                                cubit.login(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                );
                              },
                        child: state is LoginLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text("Đăng nhập"),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
