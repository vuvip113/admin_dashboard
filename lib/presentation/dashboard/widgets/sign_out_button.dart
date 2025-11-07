import 'package:admin_dashboard/common/helper/navigator/app_navigator.dart';
import 'package:admin_dashboard/presentation/login/bloc/logout_cubit.dart';
import 'package:admin_dashboard/presentation/login/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/configs/theme/app_colors.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutCubit, LogoutState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          AppNavigator.pushAndRemove(context, LoginPage());
        } else if (state is LogoutFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: IconButton(
        onPressed: () {
          context.read<LogoutCubit>().logout();
        },
        icon: Container(
          height: 40,
          width: 40,
          decoration: const BoxDecoration(
            color: AppColors.secondBackground,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.logout_rounded,
            size: 15,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
