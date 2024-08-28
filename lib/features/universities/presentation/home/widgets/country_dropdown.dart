import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_uni/assets/countries.dart';
import 'package:my_uni/features/universities/presentation/home/cubits/university_cubit.dart';

class CountryDropdown extends StatelessWidget {
  const CountryDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      width: MediaQuery.of(context).size.width - 30,
      hintText: "Select Country",
      onSelected: (value) {
        BlocProvider.of<UniversityCubit>(context)
            .loadUniversities(country: value);
      },
      dropdownMenuEntries:
          countries.split(',').map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(
          value: value,
          label: value,
        );
      }).toList(),
    );
  }
}
