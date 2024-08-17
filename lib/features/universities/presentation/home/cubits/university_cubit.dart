import 'package:my_uni/features/universities/presentation/home/cubits/university_state.dart';
import 'package:bloc/bloc.dart';
import 'package:my_uni/features/universities/services/university_service.dart';

class UniversityCubit extends Cubit<UniversityState> {
  final UniversityService universityService;

  UniversityCubit(this.universityService) : super(UniversityInitial());

  Future<void> loadUniversities() async {
    try {
      emit(UniversityLoading());
      final universities = await universityService.fetchUniversities();
      emit(UniversityLoaded(universities));
    } catch (e) {
      emit(UniversityError(e.toString()));
    }
  }
}
