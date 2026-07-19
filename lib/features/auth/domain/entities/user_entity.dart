enum UserRoles { Admin, Patient, Doctor }

class UserEntity {
  final String email;
  final String user;
  final UserRoles role;
  UserEntity({required this.email, required this.user, required this.role});
}
