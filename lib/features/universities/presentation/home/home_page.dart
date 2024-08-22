import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_uni/features/universities/presentation/details/details_page.dart';
import 'package:my_uni/features/universities/presentation/home/cubits/university_cubit.dart';
import 'package:my_uni/features/universities/presentation/home/cubits/university_state.dart';
import 'package:my_uni/features/universities/presentation/home/widgets/custom_loading.dart';
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
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: "Search Universities",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.search),
                          color: Colors.white,
                          onPressed: () {
                            final searchedText = searchController.value.text;
                            BlocProvider.of<UniversityCubit>(context)
                                .loadUniversities(name: searchedText);
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  DropdownMenu<String>(
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
                    dropdownMenuEntries: countryList
                        .map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                        value: value,
                        label: value,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  Expanded(child: _universityList(context, state)),
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
