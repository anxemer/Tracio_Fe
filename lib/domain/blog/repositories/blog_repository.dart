import 'package:dartz/dartz.dart';
import 'package:tracio_fe/data/blog/models/request/comment_blog_req.dart';
import 'package:tracio_fe/data/blog/models/request/create_blog_req.dart';
import 'package:tracio_fe/data/blog/models/request/get_reply_comment_req.dart';
import 'package:tracio_fe/data/blog/models/request/react_blog_req.dart';
import 'package:tracio_fe/data/blog/models/view/category_blog.dart';
import 'package:tracio_fe/data/blog/models/view/comment_blog_model.dart';
import 'package:tracio_fe/domain/blog/entites/category_blog.dart';
import 'package:tracio_fe/domain/blog/entites/comment_blog.dart';
import 'package:tracio_fe/domain/blog/entites/reply_comment.dart';

import '../../../core/erorr/failure.dart';
import '../../../data/blog/models/request/get_comment_req.dart';
import '../../../data/blog/models/request/reply_comment_req.dart';
import '../../../data/blog/models/view/reaction_response_model.dart';
import '../entites/blog_entity.dart';
import '../usecase/un_react_blog.dart';

abstract class BlogRepository {
  Future<Either<Failure, List<BlogEntity>>> getBlogs();
  Future<Either<Failure, ReactionResponseModel>> reactBlogs(ReactBlogReq react);
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
