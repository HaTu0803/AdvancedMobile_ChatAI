import 'package:either_dart/either.dart';

import '../../gitit/gitit.dart';
import '../../util/exception.dart';
import '../datasource/authentication_datasource.dart';

abstract class IAuthRepository {
  Future<Either<String, String>> register(String email, String password);

  Future<Either<String, String>> login(String email, String password);
}

class AuthenticationRepository extends IAuthRepository {
  final IAuthenticationDatasource _datasource = locator.get();
  @override
  Future<Either<String, String>> login(String email, String password) async {
    try {
      String token = await _datasource.login(email, password);
      if (token.isNotEmpty) {
        return const Right('login please');
      } else {
        return const Left('error');
      }
    } on ApiException catch (ex) {
      return Left('${ex.message}');
    }
  }

  @override
  Future<Either<String, String>> register(String email, String password) async {
    try {
      await _datasource.register(email, password);
      return const Right('Done');
    } on ApiException catch (ex) {
      return Left(ex.message ?? 'Error');
    }
  }
}
