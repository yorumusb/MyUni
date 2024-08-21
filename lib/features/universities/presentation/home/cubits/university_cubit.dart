import 'package:my_uni/features/universities/presentation/home/cubits/university_state.dart';
import 'package:bloc/bloc.dart';
import 'package:my_uni/features/universities/services/university_service.dart';

class UniversityCubit extends Cubit<UniversityState> {
  final UniversityService universityService;
  final int _limit = 15;

  UniversityCubit(this.universityService) : super(const UniversityState());

  Future<void> loadUniversities() async {
    try {
      emit(state.copyWith(status: UniversityStatus.loading));

      final universities = await universityService.fetchUniversities(
        offset: 0,
        limit: _limit,
      );

      emit(state.copyWith(
        status: UniversityStatus.success,
        universities: universities,
        hasReachedMax: universities.length < _limit,
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
