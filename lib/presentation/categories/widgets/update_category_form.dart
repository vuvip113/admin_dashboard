import 'dart:io';

import 'package:admin_dashboard/common/bloc/navigator/button/button_state_cubit.dart';
import 'package:admin_dashboard/common/helper/images/image_display.dart';
import 'package:admin_dashboard/core/configs/theme/app_colors.dart';
import 'package:admin_dashboard/core/utils/constants/tydefs.dart';
import 'package:admin_dashboard/core/utils/widgets/button/basic_reactive_button.dart';
import 'package:admin_dashboard/core/utils/widgets/custom_text_field.dart';
import 'package:admin_dashboard/domain/category/entities/category.dart';
import 'package:admin_dashboard/domain/category/usecase/update_category_usecase.dart';
import 'package:admin_dashboard/presentation/categories/cubit/categories_display_cubit.dart';
import 'package:admin_dashboard/presentation/categories/cubit/pick_mage_cate_cubit.dart';
import 'package:admin_dashboard/presentation/categories/widgets/category_image_card.dart';
import 'package:admin_dashboard/services/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class UpdateCategoryForm extends StatelessWidget {
  final Category? category;

  const UpdateCategoryForm({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController(
      text: category!.name,
    );

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
                File? selectedImage;

                if (state is PickMageCateSuccess) {
                  selectedImage = state.imageFile;
                }

                // Lấy ảnh server bằng helper
                String? serverImageUrl;
                if (category?.imageUrl != null) {
                  serverImageUrl = ImageDisplayHelper.generateCategoryImageURL(
                    category!.imageUrl.toString(),
                  );
                }

                return CategoryImageCard(
                  labelText: "Category",
                  imageFile: selectedImage, // ảnh user chọn
                  imageUrlForUpdateImage: serverImageUrl, // ảnh server
                  onTap: () {
                    context.read<PickMageCateCubit>().pickImage();
                  },
                );
              },
            ),
            Gap(defaultPadding),
            CustomTextField(
              controller: nameController,
              labelText: "Category",
              onSave: (val) {},
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
                        final imageCubit = context.read<PickMageCateCubit>();
                        File? selectedImage;
                        if (imageCubit.state is PickMageCateSuccess) {
                          selectedImage =
                              (imageCubit.state as PickMageCateSuccess)
                                  .imageFile;
                        }

                        final updateUseCase =
                            sl<
                              UpdateCategoryUsecase
                            >(); // gọi từ injection_container
                        final updatedCategory = category!.copyWith(
                          name: nameController.text.isNotEmpty
                              ? nameController.text
                              : category!.name,
                        );

                        buttonCubit.showLoading();

                        final result = await updateUseCase(
                          updatedCategory,
                          image: selectedImage,
                        );

                        buttonCubit.reset();

                        result.fold(
                          (failure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Lỗi: ${failure.message}'),
                              ),
                            );
                          },
                          (_) {
                            context
                                .read<CategoriesDisplayCubit>()
                                .getCategories();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Cập nhật danh mục thành công!'),
                              ),
                            );
                            Navigator.of(context).pop(); // đóng form
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
void showUpdateCategoryForm(
  BuildContext context,
  Category? category,
  CategoriesDisplayCubit categoriesCubit,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: categoriesCubit),
          BlocProvider(create: (_) => PickMageCateCubit()),
          BlocProvider(create: (_) => ButtonStateCubit()),
        ],
        child: AlertDialog(
          backgroundColor: AppColors.secondBackground,
          title: Center(
            child: Text(
              'Update Category'.toUpperCase(),
              style: TextStyle(color: AppColors.primary),
            ),
          ),
          content: UpdateCategoryForm(category: category),
        ),
      );
    },
  );
}
