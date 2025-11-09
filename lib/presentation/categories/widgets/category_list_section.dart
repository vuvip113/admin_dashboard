import 'package:admin_dashboard/common/helper/images/image_display.dart';
import 'package:admin_dashboard/core/configs/theme/app_colors.dart';
import 'package:admin_dashboard/domain/category/entities/category.dart';
import 'package:admin_dashboard/presentation/categories/cubit/categories_display_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryListSection extends StatelessWidget {
  const CategoryListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "All Categories",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          BlocBuilder<CategoriesDisplayCubit, CategoriesDisplayState>(
            builder: (context, state) {
              if (state is CategoriesDisplayLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (state is CategoriesDisplayLoaded) {
                final categories = state.categories;

                if (categories.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: Text('Chưa có danh mục nào.')),
                  );
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: DataTable(
                      columnSpacing: 16,
                      columns: const [
                        DataColumn(label: Text("Category Name")),
                        DataColumn(label: Text("Added Date")),
                        DataColumn(label: Text("Edit")),
                        DataColumn(label: Text("Delete")),
                      ],
                      rows: categories
                          .map(
                            (cat) => categoryDataRow(
                              category: cat,
                              edit: () {
                                print("Edit: ${cat.name}");
                              },
                              delete: () {
                                print("Delete: ${cat.name}");
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                );
              }

              if (state is CategoriesDisplayError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Lỗi: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                );
              }

              // State ban đầu → tự động load dữ liệu
              if (state is CategoriesDisplayInitial) {
                context.read<CategoriesDisplayCubit>().getCategories();
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

DataRow categoryDataRow({
  required Category category,
  Function? edit,
  Function? delete,
}) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                    ImageDisplayHelper.generateCategoryImageURL(
                      category.imageUrl.toString(),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(category.name.toString()),
            ),
          ],
        ),
      ),
      DataCell(Text('2025')),
      DataCell(
        IconButton(
          onPressed: () {
            if (edit != null) edit();
          },
          icon: Icon(Icons.edit, color: Colors.white),
        ),
      ),
      DataCell(
        IconButton(
          onPressed: () {
            if (delete != null) delete();
          },
          icon: Icon(Icons.delete, color: Colors.red),
        ),
      ),
    ],
  );
}
