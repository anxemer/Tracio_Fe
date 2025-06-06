// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/chat/entities/message.dart';
import 'package:Tracio/domain/chat/repositories/chat_repository.dart';
import 'package:Tracio/service_locator.dart';

class GetShopMessagesUsecaseParams {
  int entityId;
  int pageSize;
  int pageNumber;
  GetShopMessagesUsecaseParams({
    required this.entityId,
    this.pageSize = 20,
    this.pageNumber = 1,
  });

  Map<String, String> toQueryString() {
    final map = {
      "entityId": entityId.toString(),
      "pageSize": pageSize.toString(),
      "pageNumber": pageNumber.toString(),
    };

    return map;
  }
}

class GetShopMessagesUsecase
    extends Usecase<dynamic, GetShopMessagesUsecaseParams> {
  @override
  Future<Either<Failure, MessagePaginationEntity>> call(
      GetShopMessagesUsecaseParams params) async {
    return await sl<ChatRepository>().getMessages(params.toQueryString());
  }
}
