import 'package:flutter/material.dart';
import 'package:my_uni/features/universities/models/university_model.dart';

class DetailsPage extends StatelessWidget {
  final UniversityModel university;
  const DetailsPage({super.key, required this.university});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(university.name),
      ),
    );
  }
}
