import 'package:admin_dashboard/domain/auth/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({required super.uid, required super.email});

  factory UserModel.fromFirebaseUser(dynamic user) {
    return UserModel(uid: user.uid, email: user.email ?? '');
  }
}
