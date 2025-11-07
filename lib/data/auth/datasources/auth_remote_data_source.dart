import 'package:admin_dashboard/core/errors/exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:admin_dashboard/data/auth/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> login(String email, String password);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl(this.firebaseAuth);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw const ServerException(
          massage: 'Không thể đăng nhập. Người dùng không tồn tại.',
          statusCode: 404,
        );
      }

      // ✅ Trả về UserModel để tầng repository có thể dùng tiếp
      return UserModel(uid: user.uid, email: user.email ?? '');
    } on FirebaseAuthException catch (e) {
      // Xử lý lỗi Firebase chuẩn hơn
      throw ServerException(massage: "${e.message}", statusCode: 505);
    } catch (e) {
      throw ServerException(massage: 'Đăng nhập thất bại: $e', statusCode: 505);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw ServerException(massage: 'Đăng xuat thất bại: $e', statusCode: 505);
    }
  }
}
