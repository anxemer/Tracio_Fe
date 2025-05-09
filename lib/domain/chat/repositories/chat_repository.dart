import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/data/chat/models/request/post_message_req.dart';
import 'package:Tracio/domain/chat/entities/conversation.dart';
import 'package:Tracio/domain/chat/entities/message.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ConversationEntity>>> getConversations(
      Map<String, String> params);
  Future<Either<Failure, MessagePaginationEntity>> getMessages(
      Map<String, String> params);
  Future<Either<Failure, dynamic>> getConversationByGroupId(int groupId);
  Future<Either<Failure, dynamic>> postConversation(int userId);
  Future<Either<Failure, MessageEntity>> postMessage(PostMessageReq request);
  Future<Either<Failure, MessagePaginationEntity>> getShopMessages(
      int entityId, Map<String, String> params);
}
