import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/data/map/models/get_place_req.dart';
import 'package:tracio_fe/domain/map/usecase/get_location_detail.dart';
import 'package:tracio_fe/domain/map/usecase/get_locations.dart';
import 'package:tracio_fe/presentation/map/bloc/get_location_state.dart';
import 'package:tracio_fe/service_locator.dart';

class GetLocationCubit extends Cubit<GetLocationState> {
  GetLocationCubit() : super(GetLocationInitial());

  Timer? _debounce;

  void getLocationsAutoComplete(String searchedText,
      {String sessionToken = ""}) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 1800), () async {
      if (searchedText.isEmpty) return;

      emit(GetLocationsAutoCompleteLoading());
      GetPlaceReq request =
          GetPlaceReq(searchText: searchedText, sessionToken: sessionToken);
      var data =
          await sl<GetLocationAutoCompleteUseCase>().call(params: request);

      data.fold(
        (error) => emit(GetLocationsAutoCompleteFailure(errorMessage: error)),
        (data) => emit(GetLocationsAutoCompleteLoaded(places: data)),
      );
    });
  }

  Future<void> getLocationDetail(String placeId,
      {String sessionToken = ""}) async {
    emit(GetLocationDetailLoading());

    GetPlaceDetailReq request =
        GetPlaceDetailReq(placeId: placeId, sessionToken: sessionToken);

    var data = await sl<GetLocationDetailUseCase>().call(params: request);

    data.fold(
      (error) => emit(GetLocationDetailFailure(errorMessage: error)),
      (data) => emit(GetLocationDetailLoaded(placeDetail: data)),
    );
  }

  void clearSearchResults() {
    emit(GetLocationInitial());
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
