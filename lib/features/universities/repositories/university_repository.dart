import 'dart:convert';

import 'package:my_uni/features/universities/models/university_model.dart';
import 'package:my_uni/features/universities/services/university_service.dart';

class UniversityRepository {
  final UniversityService service;

  UniversityRepository({required this.service});

  Future<List<UniversityModel>> fetchUniversities() async {
    final response = await service.getAllUniversities();

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => UniversityModel.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load universities");
    }
  }
}
