import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_uni/features/universities/models/university_model.dart';

class UniversityService {
  Future<List<University>> fetchUniversities(
      {int offset = 0, int limit = 15}) async {
    final response = await http.get(
      Uri.parse(
          'http://universities.hipolabs.com/search?country=turkey&offset=$offset&limit=$limit'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => University.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load universities');
    }
  }
}
