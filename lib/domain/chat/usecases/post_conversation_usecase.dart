import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/chat/repositories/chat_repository.dart';
import 'package:Tracio/service_locator.dart';

class PostConversationUsecase extends Usecase<dynamic, int> {
  @override
  Future<Either<Failure, dynamic>> call(int params) async {
    return await sl<ChatRepository>().postConversation(params);
  }
}
