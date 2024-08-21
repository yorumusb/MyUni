import 'package:equatable/equatable.dart';

final class University extends Equatable {
  final String code;
  final String name;
  final List<String> domain;
  final String country;
  final List<String> webPage;

  const University({
    required this.code,
    required this.name,
    required this.domain,
    required this.country,
    required this.webPage,
  });

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      code: json["alpha_two_code"],
      name: json["name"],
      domain: List<String>.from(json["domains"]),
      country: json["country"],
      webPage: List<String>.from(json["web_pages"]),
    );
  }

  @override
  List<Object> get props => [code, name, domain, country, webPage];
}
