import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/chat/models/request/post_message_req.dart';
import 'package:Tracio/domain/chat/entities/message.dart';
import 'package:Tracio/domain/chat/repositories/chat_repository.dart';
import 'package:Tracio/service_locator.dart';

class PostMessageUsecase extends Usecase<dynamic, PostMessageReq> {
  @override
  Future<Either<Failure, MessageEntity>> call(PostMessageReq params) async {
    return await sl<ChatRepository>().postMessage(params);
  }
}
