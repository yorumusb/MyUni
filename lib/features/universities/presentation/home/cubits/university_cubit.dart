import 'package:my_uni/features/universities/presentation/home/cubits/university_state.dart';
import 'package:bloc/bloc.dart';
import 'package:my_uni/features/universities/services/university_service.dart';

class UniversityCubit extends Cubit<UniversityState> {
  final UniversityService universityService;
  final int _limit = 15;

  UniversityCubit(this.universityService) : super(const UniversityState());

  Future<void> loadUniversities({String? name, String? country}) async {
    try {
      emit(const UniversityState().copyWith(
        status: UniversityStatus.loading,
      ));

      final universities = await universityService.fetchUniversities(
        offset: 0,
        limit: _limit,
        name: name,
        country: country,
      );

      emit(state.copyWith(
        status: UniversityStatus.success,
        universities: universities,
        hasReachedMax: universities.length < _limit,
        name: name,
        country: country,
      ));
    } catch (e) {
      emit(state.copyWith(status: UniversityStatus.failure));
    }
  }

  Future<void> loadMoreUniversities() async {
    if (!state.hasReachedMax && state.status == UniversityStatus.success) {
      try {
        final universities = await universityService.fetchUniversities(
          offset: _limit * state.page,
          limit: _limit,
          name: state.name,
          country: state.country,
        );

        emit(state.copyWith(
          universities: List.of(state.universities)..addAll(universities),
          hasReachedMax: universities.isEmpty,
          page: state.page + 1,
        ));
      } catch (e) {
        emit(state.copyWith(status: UniversityStatus.failure));
      }
    }
  }
}
