import 'package:flutter/material.dart';
import 'theme.dart';
import 'pages/splash_page.dart';

void main() {
  runApp(const MyTokoApp());
}

class MyTokoApp extends StatelessWidget {
  const MyTokoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop Goat',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const SplashPage(),
    );
  }
}
