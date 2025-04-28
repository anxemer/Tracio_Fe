import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/chat/repositories/chat_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class PostConversationUsecase extends Usecase<dynamic, int> {
  @override
  Future<Either<Failure, dynamic>> call(int params) async {
    return await sl<ChatRepository>().postConversation(params);
  }
}
