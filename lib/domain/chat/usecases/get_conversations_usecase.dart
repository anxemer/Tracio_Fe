import 'package:dartz/dartz.dart';

import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/chat/entities/conversation.dart';
import 'package:tracio_fe/domain/chat/repositories/chat_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class GetConversationsUsecase extends Usecase<dynamic, Map<String, String>> {
  @override
  Future<Either<Failure, List<ConversationEntity>>> call(
      Map<String, String> params) async {
    return await sl<ChatRepository>().getConversations(params);
  }
}
