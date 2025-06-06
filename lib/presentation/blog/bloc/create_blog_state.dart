abstract class CreateBlogState {}

class CreateBlogInittial extends CreateBlogState {
  final String message;

  CreateBlogInittial({required this.message});
}

class CreateBlogLoading extends CreateBlogState {}

class CreateBlogSuccess extends CreateBlogState {}

class CreateBlogFail extends CreateBlogState {
  final String error;

  CreateBlogFail({required this.error});
}
