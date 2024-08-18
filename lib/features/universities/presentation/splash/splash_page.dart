import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:my_uni/features/universities/presentation/home/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.network(
        'https://cdn-icons-png.flaticon.com/512/89/89037.png',
      ),
      title: Text(
        "Universities",
        style: Theme.of(context).textTheme.displaySmall!,
      ),
      backgroundColor: Colors.grey.shade300,
      showLoader: true,
      loadingText: const Text("Loading..."),
      durationInSeconds: 2,
      navigator: const HomePage(),
    );
  }
}
