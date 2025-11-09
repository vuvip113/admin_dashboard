import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

part 'pick_mage_cate_state.dart';

class PickMageCateCubit extends Cubit<PickMageCateState> {
  PickMageCateCubit() : super(PickMageCateInitial());
  Future<void> pickImage() async {
    emit(PickMageCateLoading());
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        emit(PickMageCateSuccess(imageFile: file));
      } else {
        // Người dùng hủy chọn
        emit(PickMageCateInitial());
      }
    } catch (e) {
      emit(PickMageCateError(message: e.toString()));
    }
  }
}
