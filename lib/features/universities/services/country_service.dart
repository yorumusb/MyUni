import 'dart:convert';
import 'package:http/http.dart' as http;

class CountryService {
  final String apiUrl = "http://universities.hipolabs.com/search";

  Future<List<String>> fetchCountries() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final Set<String> countrySet = {};

      for (var item in data) {
        final country = item['country'] as String?;
        if (country != null) {
          countrySet.add(country);
        }
      }

      return countrySet.toList()..sort();
    } else {
      throw Exception('Failed to load countries');
    }
  }
}
