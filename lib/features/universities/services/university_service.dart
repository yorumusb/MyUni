import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_uni/features/universities/models/university_model.dart';

class UniversityService {
  Future<List<UniversityModel>> fetchUniversities() async {
    final response = await http.get(
      Uri.parse('http://universities.hipolabs.com/search?country=turkey'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => UniversityModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load universities');
    }
  }
}
