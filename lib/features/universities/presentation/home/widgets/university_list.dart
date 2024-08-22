import 'package:flutter/material.dart';
import 'package:my_uni/features/universities/presentation/details/details_page.dart';
import 'package:my_uni/features/universities/presentation/home/cubits/university_state.dart';
import 'package:my_uni/features/universities/presentation/home/widgets/custom_loading.dart';

class UniversityList extends StatelessWidget {
  const UniversityList({
    super.key,
    required this.controller,
    required this.context,
    required this.state,
  });

  final ScrollController controller;
  final BuildContext context;
  final UniversityState state;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      itemCount: state.universities.length + (state.hasReachedMax ? 0 : 1),
      itemBuilder: (context, index) {
        if (index < state.universities.length) {
          final university = state.universities[index];
          return Card(
            child: ListTile(
              title: Text(
                university.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              trailing: const Icon(
                Icons.arrow_right,
                color: Colors.grey,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsPage(
                      university: university,
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: CustomLoading(),
          );
        }
      },
    );
  }
}
