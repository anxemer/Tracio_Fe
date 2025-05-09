// ignore_for_file: public_member_api_docs, sort_constructors_first
class PaginationMetaDataEntity {
  final bool? isSeen;
  final int? pageNumber;
  final int? pageSize;
  final int? totalSeenBlogs;
  final int? totalSeenBlogPages;
  final int? totalPages;
  
  final bool? hasNextPage;
  final bool? hasPreviousPage;
  PaginationMetaDataEntity({
    this.isSeen,
    this.pageNumber,
    this.pageSize,
    this.totalSeenBlogs,
    this.totalSeenBlogPages,
    this.totalPages,
    this.hasNextPage,
    this.hasPreviousPage,
  });
}
