import 'package:flutter_bloc/flutter_bloc.dart';

class SelectCategoryCubit extends Cubit<int> {
  SelectCategoryCubit() : super(0);

  int selectedIndex = 0;

  void selectCate(int category) {
    selectedIndex = category;
    emit(selectedIndex);
  }
}
