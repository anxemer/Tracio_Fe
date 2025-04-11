class PaginationMetaDataEntity {
  final bool? isSeen;
  final int? pageNumber;
  final int? pageSize;
  final int? totalSeenBlogs;
  final int? totalSeenBlogPages;
  final int? totalPages;
  PaginationMetaDataEntity({
    this.isSeen,
    this.pageNumber,
    this.pageSize,
    this.totalSeenBlogs,
    this.totalSeenBlogPages,
    this.totalPages,
  });
}
