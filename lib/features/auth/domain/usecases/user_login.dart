import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repo.dart';

class UserLogIn {
  AuthRepo repo;

  UserLogIn({required this.repo});

  Future<Either<Failure, UserEntity>> call({
    required UserLoginParams userLoginParams,
  }) {
    return repo.userLogIn(userLoginParams: userLoginParams);
  }
}
