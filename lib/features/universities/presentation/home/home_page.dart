import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_uni/features/universities/presentation/home/cubits/university_cubit.dart';
import 'package:my_uni/features/universities/presentation/home/cubits/university_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: BlocBuilder<UniversityCubit, UniversityState>(
            builder: (context, state) {
              if (state is UniversityLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is UniversityLoaded) {
                return ListView.builder(
                  itemCount: state.universities.length,
                  itemBuilder: (context, index) {
                    final university = state.universities[index];
                    return ListTile(
                      title: Text(university.name),
                    );
                  },
                );
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
          )),
    );
  }

  AppBar customAppBar() {
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
