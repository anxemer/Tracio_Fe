// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:Tracio/domain/blog/entites/blog_entity.dart';
import 'package:Tracio/domain/blog/entites/pagination_meta_data_entity.dart';

class BlogResponseEntity {
  final List<BlogEntity> blogs;
  final PaginationMetaDataEntity paginationMetaDataEntity;
  BlogResponseEntity({
    required this.blogs,
    required this.paginationMetaDataEntity,
  });
}
