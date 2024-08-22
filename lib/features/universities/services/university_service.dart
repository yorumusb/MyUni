import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_uni/features/universities/models/university_model.dart';

class UniversityService {
  Future<List<University>> fetchUniversities(
      {int offset = 0, int limit = 15, String? name, String? country}) async {
    final queryParameters = {
      'offset': offset.toString(),
      'limit': limit.toString(),
    };

    if (name != null && name.isNotEmpty) {
      queryParameters.addAll({
        'name': name,
      });
    }

    if (country != null && country.isNotEmpty) {
      queryParameters.addAll({
        'country': country,
      });
    }

    final uri = Uri.http(
      'universities.hipolabs.com',
      '/search',
      queryParameters,
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => University.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load universities');
    }
  }
}
