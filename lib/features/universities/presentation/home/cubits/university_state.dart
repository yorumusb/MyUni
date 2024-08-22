import 'package:equatable/equatable.dart';
import 'package:my_uni/features/universities/models/university_model.dart';

enum UniversityStatus { initial, loading, success, failure }

final class UniversityState extends Equatable {
  final UniversityStatus status;
  final List<University> universities;
  final int page;
  final bool hasReachedMax;
  final String? name;

  const UniversityState({
    this.status = UniversityStatus.initial,
    this.universities = const <University>[],
    this.hasReachedMax = false,
    this.page = 1,
    this.name,
  });

  UniversityState copyWith(
      {UniversityStatus? status,
      List<University>? universities,
      bool? hasReachedMax,
      int? page,
      String? name}) {
    return UniversityState(
        status: status ?? this.status,
        universities: universities ?? this.universities,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        page: page ?? this.page,
        name: name ?? this.name);
  }

  @override
  List<Object?> get props => [status, universities, hasReachedMax, page, name];
}
