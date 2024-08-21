import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_uni/features/universities/presentation/details/details_page.dart';
import 'package:my_uni/features/universities/presentation/home/cubits/university_cubit.dart';
import 'package:my_uni/features/universities/presentation/home/cubits/university_state.dart';
import 'package:my_uni/features/universities/presentation/home/widgets/custom_loading.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _customAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<UniversityCubit, UniversityState>(
          listener: (context, state) {
            if (state.status == UniversityStatus.success) {
              controller.addListener(() {
                if (controller.position.atEdge && !state.hasReachedMax) {
                  if (controller.position.pixels != 0) {
                    BlocProvider.of<UniversityCubit>(context)
                        .loadMoreUniversities();
                  }
                }
              });
            }
          },
          builder: (context, state) {
            if (state.status == UniversityStatus.loading) {
              return const CustomLoading();
            } else if (state.status == UniversityStatus.success) {
              return _universityList(context, state);
            } else if (state.status == UniversityStatus.failure) {
              return const Center(
                child: Text("Failed to load universities"),
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

  ListView _universityList(BuildContext context, UniversityState state) {
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
