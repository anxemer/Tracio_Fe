import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/chat/models/request/post_message_req.dart';
import 'package:tracio_fe/domain/chat/entities/message.dart';
import 'package:tracio_fe/domain/chat/repositories/chat_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class PostMessageUsecase extends Usecase<dynamic, PostMessageReq> {
  @override
  Future<Either<Failure, MessageEntity>> call(PostMessageReq params) async {
    return await sl<ChatRepository>().postMessage(params);
  }
}
