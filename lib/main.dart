import 'package:flutter/material.dart';

import 'pages/welcome_page.dart';
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
      title: 'DoseIQ',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),
      ),
      home: const WelcomePage(),
    );
  }
}