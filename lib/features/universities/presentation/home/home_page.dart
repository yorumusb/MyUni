import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_uni/features/universities/presentation/home/cubits/university_cubit.dart';
import 'package:my_uni/features/universities/presentation/home/cubits/university_state.dart';
import 'package:my_uni/features/universities/presentation/home/widgets/app_bar_title.dart';
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
  List<String> countryList = [];
  var dropdownValue = "";
  var selectedValue = "";

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    final countries = await CountryService().fetchCountries();
    setState(() {
      countryList = countries;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(),
      ),
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
              return Column(
                children: [
                  Search(searchController: searchController),
                  const SizedBox(height: 10),
                  dropdownMenu(context),
                  const SizedBox(height: 10),
                  Expanded(
                    child: UniversityList(
                      controller: controller,
                      context: context,
                      state: state,
                    ),
                  ),
                ],
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
      ),
    );
  }

  DropdownMenu<String> dropdownMenu(BuildContext context) {
    return DropdownMenu<String>(
      width: MediaQuery.of(context).size.width - 30,
      hintText: "Select Country",
      initialSelection: selectedValue,
      onSelected: (value) {
        setState(() {
          dropdownValue = value!;
          BlocProvider.of<UniversityCubit>(context)
              .loadUniversities(country: dropdownValue);
          selectedValue = dropdownValue;
        });
      },
      dropdownMenuEntries:
          countryList.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(
          value: value,
          label: value,
        );
      }).toList(),
    );
  }
}
