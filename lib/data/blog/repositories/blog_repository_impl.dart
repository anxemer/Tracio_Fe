// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:Tracio/data/blog/models/response/edit_blog_model.dart';
import 'package:dartz/dartz.dart';

import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/network/network_infor.dart';
import 'package:Tracio/data/blog/models/request/comment_blog_req.dart';
import 'package:Tracio/data/blog/models/request/create_blog_req.dart';
import 'package:Tracio/data/blog/models/request/get_reply_comment_req.dart';
import 'package:Tracio/data/blog/models/request/react_blog_req.dart';
import 'package:Tracio/data/blog/models/request/reply_comment_req.dart';
import 'package:Tracio/data/blog/models/response/blog_response.dart';
import 'package:Tracio/data/blog/source/blog_api_service.dart';
import 'package:Tracio/domain/blog/entites/category.dart';
import 'package:Tracio/domain/blog/entites/reaction_response_entity.dart';
import 'package:Tracio/domain/blog/entites/reply_comment.dart';
import 'package:Tracio/domain/blog/repositories/blog_repository.dart';

import '../../../domain/blog/entites/comment_blog.dart';
import '../../../domain/blog/usecase/un_react_blog.dart';
import '../models/request/get_blog_req.dart';
import '../models/request/get_comment_req.dart';

// typedef _ConcreteOrBlogChooser = Future<BlogResponse> Function();

class BlogRepositoryImpl extends BlogRepository {
  final BlogApiService remoteDataSource;

  BlogRepositoryImpl({
    required this.remoteDataSource,
  });
  @override
  Future<Either<Failure, BlogResponse>> getBlogs(GetBlogReq params) async {
    try {
      var returnedData = await remoteDataSource.getBlogs(params);
      return Right(returnedData);
    } on ServerFailure {
      return Left(ServerFailure(''));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('UnAuthenticated'));
    }

    // return returnedData.fold((error) {
    //   return left(error);
    // }, (data) {
    //   var blogs = List.from(data['result']['blogs'])
    //       .map((item) => BlogModels.fromJson(item).toEntity())
    //       .toList();
    //   return right(blogs);
    // });
  }

  @override
  Future<Either<Failure, bool>> reactBlogs(ReactBlogReq react) async {
    var returnedData = await remoteDataSource.reactBlog(react);
    return returnedData.fold((error) {
      return left(ExceptionFailure(''));
    }, (data) {
      return right(true);
    });
  }

  @override
  Future<Either<Failure, bool>> createBlogs(CreateBlogReq react) async {
    try {
      var returnData = await remoteDataSource.createBlog(react);

      return Right(returnData);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategoryBlog() async {
    var returnData = await remoteDataSource.getCategoryBlog();
    return Right(returnData);
  }

  @override
  Future<Either<Failure, bool>> unReactBlog(UnReactionParam params) async {
    var returnData = await remoteDataSource.unReactBlog(params);
    return returnData.fold((error) {
      return Left(ExceptionFailure('Error'));
    }, (data) {
      return Right(true);
    });
  }

  @override
  Future<Either<Failure, CommentBlogEntity>> commentBlog(
      CommentBlogReq comment) async {
    try {
      var response = await remoteDataSource.commentBlog(comment);

      return Right(response);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, CommentBlogPaginationEntity>> getCommentBlog(
      GetCommentReq comment) async {
    try {
      var returnedData = await remoteDataSource.getCommentBlog(comment);
      return Right(returnedData);
    } on ServerFailure {
      return Left(ServerFailure(''));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('UnAuthenticated'));
    }
  }

  @override
  Future<Either<Failure, bool>> bookmarkBlogs(int blogId) async {
    await remoteDataSource.bookmarkBlog(blogId);
    return Right(true);
  }

  @override
  Future<Either<Failure, bool>> unBookmarkBlogs(int blogId) async {
    var returnData = await remoteDataSource.unBookmarkBlog(blogId);
    return returnData.fold((error) {
      return Left(ExceptionFailure('Error'));
    }, (data) {
      return Right(true);
    });
  }

  @override
  Future<Either<Failure, ReplyCommentEntity>> repCommentBlog(
      ReplyCommentReq comment) async {
    try {
      var response = await remoteDataSource.repCommentBlog(comment);

      return Right(response);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, ReplyCommentBlogPaginationEntity>> getRepCommentBlog(
      GetReplyCommentReq comment) async {
    try {
      var returnedData = await remoteDataSource.getRepCommentBlog(comment);
      return Right(returnedData);
    } on ServerFailure {
      return Left(ServerFailure(''));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('UnAuthenticated'));
    }
  }

  @override
  Future<Either<Failure, List<ReactionResponseEntity>>> getReactBlogs(
      int blog) async {
    try {
      var response = await remoteDataSource.getReactBlog(blog);
      if (response != []) {
        return Right(response);
      }
      return Right([]);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, BlogResponse>> getBookmarkBlogs(
      GetBlogReq params) async {
    try {
      var returnedData = await remoteDataSource.getBookmarkBlogs(params);
      return Right(returnedData);
    } on ServerFailure {
      return Left(ServerFailure(''));
    } on AuthenticationFailure {
      return Left(AuthenticationFailure('UnAuthenticated'));
    }
  }

  @override
  Future<Either<Failure, bool>> editBlogs(EditBlogModel react) async{
    try {
      var returnData = await remoteDataSource.editBlog(react);

      return Right(returnData);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
