import 'package:dartz/dartz.dart';

import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/chat/entities/conversation.dart';
import 'package:Tracio/domain/chat/repositories/chat_repository.dart';
import 'package:Tracio/service_locator.dart';

class GetConversationsUsecase extends Usecase<dynamic, Map<String, String>> {
  @override
  Future<Either<Failure, List<ConversationEntity>>> call(
      Map<String, String> params) async {
    return await sl<ChatRepository>().getConversations(params);
  }
}
