import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../details/details_page.dart';
import '../cubits/university_cubit.dart';
import 'custom_loading.dart';

class UniversityList extends StatefulWidget {
  const UniversityList({super.key});

  @override
  State<UniversityList> createState() => _UniversityListState();
}

class _UniversityListState extends State<UniversityList> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.atEdge && _controller.position.pixels != 0) {
        final cubit = context.read<UniversityCubit>();
        if (!cubit.state.hasReachedMax) {
          cubit.loadMoreUniversities();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<UniversityCubit>().state;

    return ListView.builder(
      controller: _controller,
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
