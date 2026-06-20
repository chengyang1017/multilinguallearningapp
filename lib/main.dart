import 'package:flutter/material.dart';
import 'screens/language_select_page.dart';

void main() {
  runApp(const VietPhraseApp());
}

class VietPhraseApp extends StatelessWidget {
  const VietPhraseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '语言学习',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2D5F4C)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5F0),
      ),
      home: const LanguageSelectPage(),
    );
  }
}