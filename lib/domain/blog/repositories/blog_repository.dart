import 'package:dartz/dartz.dart';
import 'package:tracio_fe/data/blog/models/request/comment_blog_req.dart';
import 'package:tracio_fe/data/blog/models/request/create_blog_req.dart';
import 'package:tracio_fe/data/blog/models/request/get_blog_req.dart';
import 'package:tracio_fe/data/blog/models/request/get_reply_comment_req.dart';
import 'package:tracio_fe/data/blog/models/request/react_blog_req.dart';
import 'package:tracio_fe/data/blog/models/response/category_blog.dart';
import 'package:tracio_fe/data/blog/models/response/comment_blog_model.dart';
import 'package:tracio_fe/domain/blog/entites/category_blog.dart';
import 'package:tracio_fe/domain/blog/entites/comment_blog.dart';
import 'package:tracio_fe/domain/blog/entites/reaction_response_entity.dart';
import 'package:tracio_fe/domain/blog/entites/reply_comment.dart';

import '../../../core/erorr/failure.dart';
import '../../../data/blog/models/request/get_comment_req.dart';
import '../../../data/blog/models/request/reply_comment_req.dart';
import '../../../data/blog/models/response/blog_response.dart';
import '../entites/blog_entity.dart';
import '../usecase/un_react_blog.dart';

abstract class BlogRepository {
  Future<Either<Failure, BlogResponse>> getBlogs(GetBlogReq params);
  Future<Either<Failure, ReactionResponseEntity>> reactBlogs(
      ReactBlogReq react);
  Future<Either<Failure, List<ReactionResponseEntity>>> getReactBlogs(int blog);
  Future<Either<Failure, bool>> createBlogs(CreateBlogReq react);
  Future<Either<Failure, bool>> bookmarkBlogs(int blogId);
  Future<Either<Failure, bool>> unBookmarkBlogs(int blogId);
  Future<Either<Failure, List<CategoryBlogEntity>>> getCategoryBlog();
  Future<Either<Failure, bool>> unReactBlog(UnReactionParam params);
  Future<Either<Failure, bool>> commentBlog(CommentBlogReq comment);
  Future<Either<Failure, bool>> repCommentBlog(ReplyCommentReq comment);
  Future<Either<Failure, List<CommentBlogEntity>>> getCommentBlog(
      GetCommentReq comment);
  Future<Either<Failure, List<ReplyCommentEntity>>> getRepCommentBlog(
      GetReplyCommentReq comment);
  
}
