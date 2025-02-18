import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/auth/repositories/auth_repository.dart';

import '../../../service_locator.dart';

class LogoutUseCase extends Usecase<dynamic, dynamic> {
  @override
  Future call({params}) async {
    return await sl<AuthRepository>().logout();
  }
}
