import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_uni/features/universities/presentation/home/cubits/university_cubit.dart';
import 'package:my_uni/features/universities/presentation/home/cubits/university_state.dart';
import 'package:my_uni/features/universities/presentation/home/widgets/app_bar_title.dart';
import 'package:my_uni/features/universities/presentation/home/widgets/country_dropdown.dart';
import 'package:my_uni/features/universities/presentation/home/widgets/custom_loading.dart';
import 'package:my_uni/features/universities/presentation/home/widgets/search.dart';
import 'package:my_uni/features/universities/presentation/home/widgets/university_list.dart';
import 'package:my_uni/features/universities/services/country_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = ScrollController();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Search(searchController: searchController),
            const SizedBox(height: 10),
            const CountryDropdown(),
            const SizedBox(height: 10),
            BlocConsumer<UniversityCubit, UniversityState>(
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
                  return Expanded(
                    child: UniversityList(
                      controller: controller,
                      context: context,
                      state: state,
                    ),
                  );
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
          ],
        ),
      ),
    );
  }
}
