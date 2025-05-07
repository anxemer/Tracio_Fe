import 'package:dartz/dartz.dart';
import 'package:Tracio/data/blog/models/request/comment_blog_req.dart';
import 'package:Tracio/data/blog/models/request/create_blog_req.dart';
import 'package:Tracio/data/blog/models/request/get_blog_req.dart';
import 'package:Tracio/data/blog/models/request/get_reply_comment_req.dart';
import 'package:Tracio/data/blog/models/request/react_blog_req.dart';
import 'package:Tracio/domain/blog/entites/category.dart';
import 'package:Tracio/domain/blog/entites/comment_blog.dart';
import 'package:Tracio/domain/blog/entites/reaction_response_entity.dart';
import 'package:Tracio/domain/blog/entites/reply_comment.dart';

import '../../../core/erorr/failure.dart';
import '../../../data/blog/models/request/get_comment_req.dart';
import '../../../data/blog/models/request/reply_comment_req.dart';
import '../../../data/blog/models/response/blog_response.dart';
import '../usecase/un_react_blog.dart';

abstract class BlogRepository {
  Future<Either<Failure, BlogResponse>> getBlogs(GetBlogReq params);
  Future<Either<Failure, BlogResponse>> getBookmarkBlogs(GetBlogReq params);
  Future<Either<Failure, bool>> reactBlogs(ReactBlogReq react);
  Future<Either<Failure, List<ReactionResponseEntity>>> getReactBlogs(int blog);
  Future<Either<Failure, bool>> createBlogs(CreateBlogReq react);
  Future<Either<Failure, bool>> bookmarkBlogs(int blogId);
  Future<Either<Failure, bool>> unBookmarkBlogs(int blogId);
  Future<Either<Failure, List<CategoryEntity>>> getCategoryBlog();
  Future<Either<Failure, bool>> unReactBlog(UnReactionParam params);
  Future<Either<Failure,CommentBlogEntity>> commentBlog(CommentBlogReq comment);
  Future<Either<Failure, ReplyCommentEntity>> repCommentBlog(ReplyCommentReq comment);
  Future<Either<Failure, CommentBlogPaginationEntity>> getCommentBlog(
      GetCommentReq comment);
  Future<Either<Failure, ReplyCommentBlogPaginationEntity>> getRepCommentBlog(
      GetReplyCommentReq comment);
}
