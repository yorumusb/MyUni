import 'package:my_uni/features/universities/models/university_model.dart';

abstract class UniversityState {}

class UniversityInitial extends UniversityState {}

class UniversityLoading extends UniversityState {}

class UniversityLoaded extends UniversityState {
  final List<UniversityModel> universities;

  UniversityLoaded(this.universities);
}

class UniversityError extends UniversityState {
  final String error;

  UniversityError(this.error);
}
