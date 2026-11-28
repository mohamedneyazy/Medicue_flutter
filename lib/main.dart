import 'package:flutter/material.dart';

import 'pages/splash_page.dart';
import 'widgets/common_widgets.dart';

void main() {
  runApp(const DoseIQApp());
}

class DoseIQApp extends StatelessWidget {
  const DoseIQApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MediCue',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),
      ),
      home: const SplashPage(),
    );
  }
}
