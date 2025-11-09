import 'package:admin_dashboard/presentation/categories/cubit/categories_display_cubit.dart';
import 'package:admin_dashboard/presentation/categories/widgets/add_category_form.dart';
import 'package:admin_dashboard/presentation/categories/widgets/category_list_section.dart';
import 'package:admin_dashboard/services/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => CategoriesDisplayCubit(sl()))],
      child: SafeArea(
        child: SingleChildScrollView(
          primary: false,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                "My Categories",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            ElevatedButton.icon(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16 * 1.5,
                                  vertical: 16,
                                ),
                              ),
                              onPressed: () {
                                showAddCategoryForm(context, null);
                              },
                              icon: Icon(Icons.add),
                              label: Text("Add New"),
                            ),
                            Gap(20),
                            BlocBuilder<
                              CategoriesDisplayCubit,
                              CategoriesDisplayState
                            >(
                              builder: (context, state) {
                                return IconButton(
                                  onPressed: () {
                                    context
                                        .read<CategoriesDisplayCubit>()
                                        .getCategories();
                                  },
                                  icon: Icon(Icons.refresh),
                                );
                              },
                            ),
                          ],
                        ),
                        Gap(16),
                        CategoryListSection(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
