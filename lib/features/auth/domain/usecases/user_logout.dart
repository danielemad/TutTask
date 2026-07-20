import '../repositories/auth_repo.dart';

class UserLogout {
  AuthRepo repo;

  UserLogout({required this.repo});

  void call() {
    repo.userLogOut();
  }
}
