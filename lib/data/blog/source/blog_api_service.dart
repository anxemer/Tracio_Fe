import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tracio_fe/core/constants/api_url.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/network/dio_client.dart';
import 'package:tracio_fe/data/blog/models/request/comment_blog_req.dart';
import 'package:tracio_fe/data/blog/models/request/create_blog_req.dart';
import 'package:tracio_fe/data/blog/models/request/get_blog_req.dart';
import 'package:tracio_fe/data/blog/models/request/get_comment_req.dart';
import 'package:tracio_fe/data/blog/models/request/get_reply_comment_req.dart';
import 'package:tracio_fe/data/blog/models/request/react_blog_req.dart';
import 'package:tracio_fe/data/blog/models/request/reply_comment_req.dart';
import 'package:tracio_fe/data/blog/models/response/blog_response.dart';
import 'package:tracio_fe/data/blog/models/response/category_model.dart';
import 'package:tracio_fe/data/blog/models/response/comment_blog_model.dart';
import 'package:tracio_fe/data/blog/models/response/get_reaction_blog.dart';
import 'package:tracio_fe/data/blog/models/response/reply_comment_model.dart';
import 'package:tracio_fe/service_locator.dart';

import '../../../domain/blog/usecase/un_react_blog.dart';

abstract class BlogApiService {
  Future<BlogResponse> getBlogs(GetBlogReq getBlog);
  Future<Either> reactBlog(ReactBlogReq react);
  Future<bool> createBlog(CreateBlogReq react);
  Future<Either> bookmarkBlog(int blogId);
  Future<Either> unBookmarkBlog(int blogId);
  Future<List<CategoryModel>> getCategoryBlog();
  Future<Either> unReactBlog(UnReactionParam params);
  Future<List<GetReactionBlogResponse>> getReactBlog(int reactId);
  Future<Either> commentBlog(CommentBlogReq comment);
  Future<List<CommentBlogModel>> getCommentBlog(GetCommentReq comment);
  Future<List<ReplyCommentModel>> getRepCommentBlog(GetReplyCommentReq comment);
  Future<Either> repCommentBlog(ReplyCommentReq comment);
}

class BlogApiServiceImpl extends BlogApiService {
  @override
  Future<BlogResponse> getBlogs(GetBlogReq getBlog) async {
    // final params = {
    //   'userId': getBlog.userId.toString(),
    //   'categoryId': getBlog.categoryId.toString(),
    //   'pageSize': getBlog.pageSize.toString(),
    //   'pageNumber': getBlog.pageNumber.toString(),
    //   'ascending': getBlog.ascending.toString(),
    // };
    Uri apiUrl = ApiUrl.urlGetBlog(getBlog.toQueryParams());

    var response = await sl<DioClient>().get(apiUrl.toString());
    if (response.statusCode == 200) {
      return BlogResponse.fromMap(response.data);
    } else {
      if (response.statusCode == 401) {
        throw AuthenticationFailure(response.statusMessage.toString());
      }
      throw ServerFailure(response.statusMessage.toString());
    }
  }

  @override
  Future<Either> reactBlog(ReactBlogReq react) async {
    try {
      var response =
          await sl<DioClient>().post(ApiUrl.reactBlog, data: react.toJson());
      return right(response.data['result']);
    } on DioException catch (e) {
      return left(e.response!.data['message']);
    }
  }

  @override
  Future<bool> createBlog(CreateBlogReq request) async {
    try {
      FormData formData = await request.toFormData();
      var response = await sl<DioClient>()
          .post(isMultipart: true, ApiUrl.createBlog, data: formData);
      if (response.statusCode == 201) {
        return true;
      }
      throw ServerFailure(response.data['message']);
    } on DioException catch (e) {
      throw ServerFailure(
          e.response?.data['message'] ?? e.message ?? 'Network error');
    }
  }

  @override
  Future<List<CategoryModel>> getCategoryBlog() async {
    try {
      var response = await sl<DioClient>().get(ApiUrl.categoryBlog);
      if (response.statusCode == 200) {
        return List<CategoryModel>.from(response.data['result']['categories']
            .map((c) => CategoryModel.fromMap(c)));
      }

      return [];
    } on DioException catch (e) {
      return [];
    }
  }

  @override
  Future<Either> unReactBlog(UnReactionParam params) async {
    try {
      await sl<DioClient>().delete('${ApiUrl.unReactBlog}/${params.id}',
          queryParameters: {'entityType': params.type});

      return right(true);
    } on DioException catch (e) {
      return left(e);
    }
  }

  @override
  Future<List<GetReactionBlogResponse>> getReactBlog(int reactId) async {
    try {
      var response = await sl<DioClient>()
          .get('${ApiUrl.getReactBlog}/$reactId/reactions');
      // var listReact = List.from(response.data['result']['reactions'])
      //     .map((e) => GetReactionBlogResponse.fromMap(e))
      //     .toList();
      return List<GetReactionBlogResponse>.from(response.data['result']
              ['reactions']
          .map((x) => GetReactionBlogResponse.fromMap(x)));
    } on DioException catch (e) {
      return e.response?.data['message'] ?? "Lỗi server: ${e.message}";
    }
  }

  @override
  Future<Either> commentBlog(CommentBlogReq comment) async {
    try {
      FormData form = await comment.toFormData();

      var response = await sl<DioClient>()
          .post(ApiUrl.commentBlog, isMultipart: true, data: form);
      return Right(response.data['message']);
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(ServerFailure(
            e.response?.data['message'] ?? "Lỗi server: ${e.message}"));
      } else {
        return Left(NetworkFailure("Không có kết nối mạng: ${e.message}"));
      }
    } catch (e) {
      return Left(ExceptionFailure("Lỗi không xác định: $e"));
    }
  }

  @override
  Future<List<CommentBlogModel>> getCommentBlog(GetCommentReq comment) async {
    final params = {
      if (comment.commentId != null) 'commentId': comment.commentId.toString(),
      'pageSize': comment.pageSize.toString(),
      'pageNumber': comment.pageNumber.toString(),
      'ascending': comment.ascending.toString(),
    };

    try {
      var response = await sl<DioClient>()
          .get(ApiUrl.urlGetBlogComments(comment.blogId, params).toString());

      if (response.statusCode != 200 ||
          response.data == null ||
          response.data['result'] == null) {
        return [];
      }

      var result = response.data['result'];

      int totalComments = result['totalComment'] ?? 0;
      if (totalComments <= 0) {
        return []; // Không có comment nào
      }

      if (result['comments'] != null) {
        return List.from(result['comments'])
            .map((e) => CommentBlogModel.fromMap(e))
            .toList();
      }

      if (result['blog'] != null && result['comments'] != null) {
        return List.from(result['comments'])
            .map((e) => CommentBlogModel.fromMap(e))
            .toList();
      }

      return [];
    } catch (e) {
      print("Error fetching comments: $e");
      return [];
    }
  }

  @override
  Future<Either> bookmarkBlog(int blogId) async {
    try {
      var response = await sl<DioClient>()
          .post(ApiUrl.bookmarkBlog, data: {'blogId': blogId});
      return right(response.data['result']);
    } on DioException catch (e) {
      return left(e.response!.data['message']);
    }
  }

  @override
  Future<Either> unBookmarkBlog(int blogId) async {
    try {
      await sl<DioClient>().delete('${ApiUrl.bookmarkBlog}/$blogId');
      return right(true);
    } on DioException catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either> repCommentBlog(ReplyCommentReq comment) async {
    try {
      FormData formData = await comment.toFormData();

      final response = await sl<DioClient>()
          .post(ApiUrl.repCommentBlog, // URL endpoint để reply comment
              data: formData);

      if (response.statusCode == 400) {
        print('Error');
      }
      return Right(response.data);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure(e.message ?? "Serve Error"));
      }
      return Left(ServerFailure("Have some problem"));
    }
  }

  @override
  Future<List<ReplyCommentModel>> getRepCommentBlog(
      GetReplyCommentReq comment) async {
    try {
      var response = await sl<DioClient>().get(ApiUrl.urlGetRepComments(
              comment.commentId, comment.pageNumber, comment.pageSize)
          .toString());
      if (response.statusCode != 200 ||
          response.data == null ||
          response.data['result'] == null) {
        return [];
      }

      var result = response.data['result'];

      int totalReplies = result['totalReply'] ?? 0;
      if (totalReplies <= 0) {
        return []; // Không có comment nào
      }

      if (result['replies'] != null) {
        return List.from(result['replies'])
            .map((e) => ReplyCommentModel.fromJson(e))
            .toList();
      }

      if (result['comment'] != null) {
        return List.from(result['comments'])
            .map((e) => ReplyCommentModel.fromJson(e))
            .toList();
      }

      return [];
    } catch (e) {
      print("Error fetching comments: $e");
      return [];
    }
  }
}
