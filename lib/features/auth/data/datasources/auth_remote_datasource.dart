import '../../../../core/databases/api/api_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/params/params.dart';
import '../models/user_model.dart';

class AuthRemoteDatasource {
  final ApiConsumer _apiConsumer;

  AuthRemoteDatasource({required this._apiConsumer});

  Future<UserModel> userLogIn({
    required UserLoginParams userLoginParams,
  }) async {
    final response = await _apiConsumer.post(
      "${EndPoints.baserUrl}${EndPoints.login}",
      data: {
        "email": userLoginParams.email,
        "password": userLoginParams.password,
      },
    );
    return UserModel.fromJson(response);
  }
}
