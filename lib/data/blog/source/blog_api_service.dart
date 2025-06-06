import 'package:Tracio/data/blog/models/response/edit_blog_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:Tracio/core/constants/api_url.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/network/dio_client.dart';
import 'package:Tracio/data/blog/models/request/comment_blog_req.dart';
import 'package:Tracio/data/blog/models/request/create_blog_req.dart';
import 'package:Tracio/data/blog/models/request/get_blog_req.dart';
import 'package:Tracio/data/blog/models/request/get_comment_req.dart';
import 'package:Tracio/data/blog/models/request/get_reply_comment_req.dart';
import 'package:Tracio/data/blog/models/request/react_blog_req.dart';
import 'package:Tracio/data/blog/models/request/reply_comment_req.dart';
import 'package:Tracio/data/blog/models/response/blog_response.dart';
import 'package:Tracio/data/blog/models/response/category_model.dart';
import 'package:Tracio/data/blog/models/response/get_comment_blog_rep.dart';
import 'package:Tracio/data/blog/models/response/get_reaction_blog.dart';
import 'package:Tracio/data/blog/models/response/get_reply_comment_rep.dart';
import 'package:Tracio/service_locator.dart';

import '../../../domain/blog/usecase/un_react_blog.dart';
import '../models/response/comment_blog_model.dart';
import '../models/response/reply_comment_model.dart';

abstract class BlogApiService {
  Future<BlogResponse> getBlogs(GetBlogReq getBlog);
  Future<BlogResponse> getBookmarkBlogs(GetBlogReq getBlog);
  Future<Either> reactBlog(ReactBlogReq react);
  Future<bool> createBlog(CreateBlogReq react);
  Future<bool> editBlog(EditBlogModel react);
  Future<Either> bookmarkBlog(int blogId);
  Future<Either> unBookmarkBlog(int blogId);
  Future<List<CategoryModel>> getCategoryBlog();
  Future<Either> unReactBlog(UnReactionParam params);
  Future<List<GetReactionBlogResponse>> getReactBlog(int reactId);
  Future<CommentBlogModel> commentBlog(CommentBlogReq comment);
  Future<GetCommentBlogRep> getCommentBlog(GetCommentReq comment);
  Future<GetReplyCommentRepMode> getRepCommentBlog(GetReplyCommentReq comment);
  Future<ReplyCommentModel> repCommentBlog(ReplyCommentReq comment);
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
      await sl<DioClient>().post(ApiUrl.reactBlog, data: react.toJson());
      return right(true);
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
  Future<CommentBlogModel> commentBlog(CommentBlogReq comment) async {
    try {
      FormData form = await comment.toFormData();

      var response = await sl<DioClient>()
          .post(ApiUrl.commentBlog, isMultipart: true, data: form);
      return CommentBlogModel.fromMap(response.data['result']);
    } on DioException catch (e) {
      if (e.response != null) {
        throw (ServerFailure(
            e.response?.data['message'] ?? "Lỗi server: ${e.message}"));
      } else {
        throw (NetworkFailure("Không có kết nối mạng: ${e.message}"));
      }
    } on AuthenticationFailure catch (e) {
      throw (AuthenticationFailure("Lỗi không xác định: $e"));
    }
  }

  @override
  Future<GetCommentBlogRep> getCommentBlog(GetCommentReq comment) async {
    final params = {
      if (comment.commentId != null) 'commentId': comment.commentId.toString(),
      'pageSize': '50',
      'pageNumber': comment.pageNumber.toString(),
    };

    try {
      var response = await sl<DioClient>()
          .get(ApiUrl.urlGetBlogComments(comment.blogId, params).toString());

      if (response.statusCode == 200) {
        final responseData = GetCommentBlogRep.fromMap(response.data["result"]);
        return responseData;
      } else {
        throw ExceptionFailure('Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw ExceptionFailure(
          e.response?.data['message'] ?? 'An error occurred');
    } catch (e) {
      throw ExceptionFailure('An unexpected error occurred: $e');
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
  Future<ReplyCommentModel> repCommentBlog(ReplyCommentReq comment) async {
    try {
      FormData formData = await comment.toFormData();

      final response = await sl<DioClient>()
          .post(ApiUrl.repCommentBlog, // URL endpoint để reply comment
              data: formData);

      if (response.statusCode == 400) {
        throw AuthenticationFailure('');
      }
      return ReplyCommentModel.fromJson(response.data['result']);
    } catch (e) {
      if (e is DioException) {
        throw (ServerFailure(e.message ?? "Serve Error"));
      }
      throw (ServerFailure("Have some problem"));
    }
  }

  @override
  Future<GetReplyCommentRepMode> getRepCommentBlog(
      GetReplyCommentReq comment) async {
    try {
      var response = await sl<DioClient>().get(
          ApiUrl.urlGetRepComments(comment.commentId, comment.pageNumber, 50)
              .toString());
      if (response.statusCode == 200) {
        final responseData =
            GetReplyCommentRepMode.fromMap(response.data["result"]);
        return responseData;
      } else {
        throw ExceptionFailure('Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw ExceptionFailure(
          e.response?.data['message'] ?? 'An error occurred');
    } catch (e) {
      throw ExceptionFailure('An unexpected error occurred: $e');
    }
  }

  @override
  Future<BlogResponse> getBookmarkBlogs(GetBlogReq getBlog) async {
    Uri apiUrl = ApiUrl.urlGetBookMarkBlog(getBlog.toQueryParams());

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
  Future<bool> editBlog(EditBlogModel react) async {
    try {
      var response = await sl<DioClient>()
          .put('${ApiUrl.createBlog}/${react.bloId}', data: react.toMap());
      if (response.statusCode == 200) {
        return true;
      }
      if (response.statusCode == 401) {
        throw AuthenticationFailure('');
      }
      throw ServerFailure(response.data['message']);
    } on DioException catch (e) {
      throw ServerFailure(
          e.response?.data['message'] ?? e.message ?? 'Network error');
    }
  }
}
