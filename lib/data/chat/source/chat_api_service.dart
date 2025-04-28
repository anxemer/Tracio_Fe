import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tracio_fe/core/constants/api_url.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/network/dio_client.dart';
import 'package:tracio_fe/data/chat/models/conversation.dart';
import 'package:tracio_fe/data/chat/models/message.dart';
import 'package:tracio_fe/data/chat/models/request/post_message_req.dart';
import 'package:tracio_fe/domain/chat/entities/message.dart';
import 'package:tracio_fe/service_locator.dart';

abstract class ChatApiService {
  Future<Either<Failure, List<ConversationModel>>> getConversations(
      {Map<String, String>? params});
  Future<Either<Failure, MessagePaginationModel>> getMessages(
      Map<String, String> params);
  Future<Either<Failure, MessageEntity>> postMessage(PostMessageReq request);
  Future<Either<Failure, dynamic>> postConversation(int userId);
  Future<Either<Failure, dynamic>> getConversationByGroupId(int groupId);
}

class ChatApiServiceImpl extends ChatApiService {
  @override
  Future<Either<Failure, List<ConversationModel>>> getConversations(
      {Map<String, String>? params}) async {
    try {
      var response = await sl<DioClient>()
          .get(ApiUrl.urlGetConversations(params).toString());

      if (response.statusCode == 200) {
        List<dynamic> conversationsData =
            response.data['result']['conversations'];
        List<ConversationModel> conversations = conversationsData
            .map((conversation) => ConversationModel.fromMap(conversation))
            .toList();

        return right(conversations);
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(
          ExceptionFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, MessagePaginationModel>> getMessages(
      Map<String, String> params) async {
    try {
      var response =
          await sl<DioClient>().get(ApiUrl.urlGetMessages(params).toString());

      if (response.statusCode == 200) {
        var responseData =
            MessagePaginationModel.fromMap(response.data['result']);
        return right(responseData);
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(
          ExceptionFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> postMessage(
      PostMessageReq request) async {
    try {
      FormData formData = await request.toFormData();
      var response = await sl<DioClient>().post(
        ApiUrl.urlPostMessages.toString(),
        data: formData,
        options: Options(contentType: "multipart/form-data"),
      );

      if (response.statusCode == 201) {
        return right(MessageModel.fromMap(
            response.data['result'] as Map<String, dynamic>));
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(
          ExceptionFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> getConversationByGroupId(int groupId) async {
    try {
      var response = await sl<DioClient>()
          .get(ApiUrl.urlGetConversationByGroupId(groupId).toString());

      if (response.statusCode == 200) {
        return right(null);
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(
          ExceptionFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> postConversation(int userId) async {
    try {
      var response = await sl<DioClient>()
          .post(ApiUrl.urlPostConversation.toString(), data: userId);

      if (response.statusCode == 201) {
        return right(null);
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(
          ExceptionFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }
}
