import 'package:http/http.dart' as http;

class UniversityService {
  Future<http.Response> getAllUniversities() {
    return http.get(
      Uri.parse("http://universities.hipolabs.com/search?country=turkey"),
    );
  }
}
