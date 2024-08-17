class UniversityModel {
  final String code;
  final String name;
  final List<String> domain;
  final String country;
  final List<String> webPage;

  UniversityModel({
    required this.code,
    required this.name,
    required this.domain,
    required this.country,
    required this.webPage,
  });

  factory UniversityModel.fromJson(Map<String, dynamic> json) {
    return UniversityModel(
      code: json["alpha_two_code"],
      name: json["name"],
      domain: List<String>.from(json["domains"]),
      country: json["country"],
      webPage: List<String>.from(json["web_pages"]),
    );
  }
}
