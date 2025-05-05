import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/data/chat/models/request/post_message_req.dart';
import 'package:tracio_fe/data/chat/source/chat_api_service.dart';
import 'package:tracio_fe/domain/chat/entities/conversation.dart';
import 'package:tracio_fe/domain/chat/entities/message.dart';
import 'package:tracio_fe/domain/chat/repositories/chat_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class ChatRepositoryImpl extends ChatRepository {
  @override
  Future<Either<Failure, dynamic>> getConversationByGroupId(int groupId) async {
    var returnedData =
        await sl<ChatApiService>().getConversationByGroupId(groupId);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, List<ConversationEntity>>> getConversations(
      Map<String, String> params) async {
    var returnedData =
        await sl<ChatApiService>().getConversations(params: params);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, MessagePaginationEntity>> getMessages(
      Map<String, String> params) async {
    var returnedData = await sl<ChatApiService>().getMessages(params);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, dynamic>> postConversation(int userId) async {
    var returnedData = await sl<ChatApiService>().postConversation(userId);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, MessageEntity>> postMessage(
      PostMessageReq request) async {
    var returnedData = await sl<ChatApiService>().postMessage(request);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, MessagePaginationEntity>> getShopMessages(
      int entityId, Map<String, String> params) async {
    var returnedData =
        await sl<ChatApiService>().getShopMessages(entityId, params);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }
}
