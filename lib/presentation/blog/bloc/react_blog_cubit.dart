import 'package:flutter_bloc/flutter_bloc.dart';

class ReactBlogCubit extends Cubit<bool> {
  ReactBlogCubit() : super(true);

  bool isReact = true;
  void reactBlog(bool isReaction) async {
    isReact = isReaction;
    emit(isReact);
  }
}
