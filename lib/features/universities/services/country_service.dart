import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CountryService {
  final String apiUrl = "http://universities.hipolabs.com/search";
  static List<String>? _cachedCountries;

  Future<List<String>> fetchCountries() async {
    if (_cachedCountries != null) {
      return _cachedCountries!;
    }

    final prefs = await SharedPreferences.getInstance();
    final storedCountries = prefs.getStringList('countries');

    if (storedCountries != null) {
      _cachedCountries = storedCountries;
      return _cachedCountries!;
    }

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

      _cachedCountries = countrySet.toList()..sort();

      await prefs.setStringList('countries', _cachedCountries!);

      return _cachedCountries!;
    } else {
      throw Exception('Failed to load countries');
    }
  }
}
