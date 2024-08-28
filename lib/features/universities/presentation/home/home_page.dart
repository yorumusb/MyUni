import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/university_cubit.dart';
import 'cubits/university_state.dart';
import 'widgets/app_bar_title.dart';
import 'widgets/country_dropdown.dart';
import 'widgets/custom_loading.dart';
import 'widgets/search.dart';
import 'widgets/university_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            Search(),
            const SizedBox(height: 10),
            const CountryDropdown(),
            const SizedBox(height: 10),
            BlocBuilder<UniversityCubit, UniversityState>(
              builder: (context, state) {
                if (state.status == UniversityStatus.loading) {
                  return const CustomLoading();
                } else if (state.status == UniversityStatus.success) {
                  return const Expanded(
                    child: UniversityList(),
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
