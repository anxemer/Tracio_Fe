// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/chat/entities/message.dart';
import 'package:Tracio/domain/chat/repositories/chat_repository.dart';
import 'package:Tracio/service_locator.dart';

class GetMessagesUsecaseParams {
  String conversationId;
  String? messageId;
  int pageSize;
  int pageNumber;
  GetMessagesUsecaseParams({
    required this.conversationId,
    this.messageId,
    this.pageSize = 20,
    this.pageNumber = 1,
  });

  Map<String, String> toQueryString() {
    final map = {
      "conversationId": conversationId,
      "pageSize": pageSize.toString(),
      "pageNumber": pageNumber.toString(),
    };

    if (messageId != null) {
      map["messageId"] = messageId!;
    }

    return map;
  }
}

class GetMessagesUsecase extends Usecase<dynamic, GetMessagesUsecaseParams> {
  @override
  Future<Either<Failure, MessagePaginationEntity>> call(
      GetMessagesUsecaseParams params) async {
    return await sl<ChatRepository>().getMessages(params.toQueryString());
  }
}
