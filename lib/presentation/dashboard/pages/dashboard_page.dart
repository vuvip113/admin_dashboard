import 'package:admin_dashboard/common/bloc/navigator/navigation_cubit.dart';
import 'package:admin_dashboard/core/configs/assets/app_images.dart';
import 'package:admin_dashboard/core/configs/theme/app_colors.dart';
import 'package:admin_dashboard/presentation/categories/pages/categories.dart';
import 'package:admin_dashboard/presentation/dashboard/widgets/sign_out_button.dart';
import 'package:admin_dashboard/presentation/home/pages/home_page.dart';
import 'package:admin_dashboard/presentation/login/bloc/logout_cubit.dart';
import 'package:admin_dashboard/services/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  String _getTitle(NavigationTab tab) {
    switch (tab) {
      case NavigationTab.categories:
        return 'Categories';
      default:
        return 'Home';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<NavigationCubit>();
    Widget body;

    switch (cubit.state) {
      case NavigationTab.categories:
        body = const CategoriesPage();
        break;
      default:
        body = const HomePage();
    }

    return BlocProvider(
      create: (context) => LogoutCubit(sl()),
      child: Scaffold(
        body: Row(
          children: [
            // === SIDEBAR ===
            Container(
              width: 220,
              color: AppColors.blackBackground,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Logo
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      AppImages.logo,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: NavigationRail(
                      backgroundColor: AppColors.blackBackground,
                      selectedIndex: NavigationTab.values.indexOf(cubit.state),
                      onDestinationSelected: (index) {
                        context.read<NavigationCubit>().changeTab(
                          NavigationTab.values[index],
                        );
                      },
                      labelType: NavigationRailLabelType.all,
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.home_outlined),
                          selectedIcon: Icon(Icons.home),
                          label: Text('Home'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.category_outlined),
                          selectedIcon: Icon(Icons.category),
                          label: Text('Categories'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // === MAIN CONTENT ===
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // === TOP BAR ===
                  Container(
                    height: 70,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        // Title
                        Text(
                          _getTitle(cubit.state),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),

                        // Search bar
                        SizedBox(
                          width: 250,
                          height: 40,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              prefixIcon: const Icon(Icons.search),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),

                        // User info
                        Row(
                          children: [
                            Icon(
                              Icons.account_circle,
                              color: const Color.fromARGB(255, 29, 28, 28),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Admin',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            SignOutButton(),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // === PAGE CONTENT ===
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: body,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
