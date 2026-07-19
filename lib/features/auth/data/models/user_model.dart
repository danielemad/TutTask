import '../../../../core/databases/api/end_points.dart';

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  final String token;
  UserModel({
    required super.email,
    required super.user,
    required super.role,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json[ApiKey.email] ?? "PATIENT EMAIL",
      user: json[ApiKey.user] ?? "PATIENT NAME",
      token: json[ApiKey.token] ?? "PATIENT TOKEN",
      role: UserRoles.values.firstWhere((e) => e.name == json[ApiKey.roles][0]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.email: email,
      ApiKey.user: user,
      ApiKey.token: token,
      ApiKey.roles: role.name,
    };
  }
}
