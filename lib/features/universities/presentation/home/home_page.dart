import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_uni/features/universities/presentation/details/details_page.dart';
import 'package:my_uni/features/universities/presentation/home/cubits/university_cubit.dart';
import 'package:my_uni/features/universities/presentation/home/cubits/university_state.dart';
import 'package:my_uni/features/universities/presentation/home/widgets/custom_loading.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _customAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocBuilder<UniversityCubit, UniversityState>(
          builder: (context, state) {
            if (state is UniversityLoading) {
              return const CustomLoading();
            } else if (state is UniversityLoaded) {
              return _universityList(context, state);
            } else if (state is UniversityError) {
              return Center(
                child: Text("Failed to load universities: ${state.error}"),
              );
            } else {
              return const Center(
                child: Text("Please wait..."),
              );
            }
          },
        ),
      ),
    );
  }

  ListView _universityList(BuildContext context, UniversityLoaded state) {
    final cubit = BlocProvider.of<UniversityCubit>(context);
    final controller = ScrollController();
    bool isLoadingMore = false;

    controller.addListener(() {
      if (controller.position.atEdge) {
        if (controller.position.pixels != 0 && !isLoadingMore) {
          isLoadingMore = true;
          cubit.loadMoreUniversities().then((_) => isLoadingMore = false);
        }
      }
    });

    return ListView.builder(
      controller: controller,
      itemCount: state.universities.length + 1,
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

  AppBar _customAppBar() {
    return AppBar(
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Universities"),
          SizedBox(
            width: 10,
          ),
          Text("🏫"),
        ],
      ),
    );
  }
}
