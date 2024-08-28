import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_uni/features/universities/presentation/home/cubits/university_cubit.dart';

class Search extends StatefulWidget {
  Search({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: widget.searchController,
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
              final searchedText = widget.searchController.value.text;
              BlocProvider.of<UniversityCubit>(context)
                  .loadUniversities(name: searchedText);
            },
          ),
        )
      ],
    );
  }
}
