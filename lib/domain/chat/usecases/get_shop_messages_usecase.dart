// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/chat/entities/message.dart';
import 'package:tracio_fe/domain/chat/repositories/chat_repository.dart';
import 'package:tracio_fe/service_locator.dart';

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
