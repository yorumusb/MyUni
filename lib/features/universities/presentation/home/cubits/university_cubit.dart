import 'package:my_uni/features/universities/models/university_model.dart';
import 'package:my_uni/features/universities/presentation/home/cubits/university_state.dart';
import 'package:bloc/bloc.dart';
import 'package:my_uni/features/universities/services/university_service.dart';

class UniversityCubit extends Cubit<UniversityState> {
  final UniversityService universityService;
  List<UniversityModel> _universities = [];
  int _offset = 0;
  final int _limit = 15;

  UniversityCubit(this.universityService) : super(UniversityInitial());

  Future<void> loadUniversities() async {
    try {
      emit(UniversityLoading());
      _offset = 0;
      final universities = await universityService.fetchUniversities(
        offset: _offset,
        limit: _limit,
      );
      _universities = universities;
      _offset += _limit;
      emit(UniversityLoaded(_universities));
    } catch (e) {
      emit(UniversityError(e.toString()));
    }
  }

  Future<void> loadMoreUniversities() async {
    if (state is UniversityLoaded) {
      try {
        final universities = await universityService.fetchUniversities(
          offset: _offset,
          limit: _limit,
        );
        if (universities.isNotEmpty) {
          _universities.addAll(universities);
          _offset += _limit;
          emit(UniversityLoaded(_universities));
        }
      } catch (e) {
        emit(UniversityError(e.toString()));
      }
    }
  }
}
