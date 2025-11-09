import 'dart:io';

import 'package:admin_dashboard/common/bloc/navigator/button/button_state_cubit.dart';
import 'package:admin_dashboard/core/configs/theme/app_colors.dart';
import 'package:admin_dashboard/core/utils/constants/tydefs.dart';
import 'package:admin_dashboard/core/utils/widgets/button/basic_reactive_button.dart';
import 'package:admin_dashboard/core/utils/widgets/custom_text_field.dart';
import 'package:admin_dashboard/domain/category/entities/category.dart';
import 'package:admin_dashboard/domain/category/usecase/add_category_usecase.dart';
import 'package:admin_dashboard/presentation/categories/cubit/categories_display_cubit.dart';
import 'package:admin_dashboard/presentation/categories/cubit/pick_mage_cate_cubit.dart';
import 'package:admin_dashboard/presentation/categories/widgets/category_image_card.dart';
import 'package:admin_dashboard/services/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class CategorySubmitForm extends StatelessWidget {
  final Category? category;

  const CategorySubmitForm({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    final size = MediaQuery.of(context).size;

    return Form(
      child: Container(
        padding: EdgeInsets.all(defaultPadding),
        width: size.width * 0.3,
        decoration: BoxDecoration(
          color: AppColors.secondBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Gap(defaultPadding),
            // Hiển thị khung chọn ảnh tạm
            BlocBuilder<PickMageCateCubit, PickMageCateState>(
              builder: (context, state) {
                File? image;
                if (state is PickMageCateSuccess) {
                  image = state.imageFile;
                }

                return CategoryImageCard(
                  labelText: "Category",
                  imageFile: image,
                  imageUrlForUpdateImage: category?.imageUrl,
                  onTap: () {
                    context.read<PickMageCateCubit>().pickImage();
                  },
                );
              },
            ),
            Gap(defaultPadding),
            CustomTextField(
              controller: nameController,
              labelText: 'Category Name',
              onSave: (val) {},
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a category name';
                }
                return null;
              },
            ),
            Gap(defaultPadding * 2),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.secondBackground,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Đóng popup
                    },
                    child: const Text('Cancel'),
                  ),
                  Gap(defaultPadding),
                  SizedBox(
                    width: 100,
                    child: BasicReactiveButton(
                      title: 'Submit',
                      onPressed: () async {
                        final buttonCubit = context.read<ButtonStateCubit>();
                        final addCategoryUsecase = sl<AddCategoryUsecase>();
                        final imageFile =
                            context.read<PickMageCateCubit>().state
                                is PickMageCateSuccess
                            ? (context.read<PickMageCateCubit>().state
                                      as PickMageCateSuccess)
                                  .imageFile
                            : null;

                        final category = Category(
                          id: '',
                          name: nameController.text,
                          imageUrl: '',
                          createdAt: DateTime.now(),
                        );

                        // Bật state loading trên nút
                        buttonCubit.showLoading();

                        // Gọi usecase
                        final result = await addCategoryUsecase(
                          category,
                          image: imageFile,
                        );

                        // Tắt loading
                        buttonCubit.reset();

                        // Xử lý kết quả
                        result.fold(
                          (failure) =>
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('❌ ${failure.message}')),
                              ),
                          (_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('✅ Added category successfully!'),
                              ),
                            );
                            Navigator.of(context).pop(); // Đóng popup form
                          },
                        );
                      },
                      height: 50,
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

// 👉 Hàm hiển thị popup Add Category
void showAddCategoryForm(BuildContext context, Category? category) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => PickMageCateCubit()),
          BlocProvider(create: (_) => ButtonStateCubit()),
        ],
        child: AlertDialog(
          backgroundColor: AppColors.secondBackground,
          title: Center(
            child: Text(
              'Add Category'.toUpperCase(),
              style: TextStyle(color: AppColors.primary),
            ),
          ),
          content: CategorySubmitForm(category: category),
        ),
      );
    },
  );
}
