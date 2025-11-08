import 'package:flutter/material.dart';
import 'screens/flashcards_screen.dart';

void main() {
  runApp(const FlashcardsApp());
}

class FlashcardsApp extends StatelessWidget {
  const FlashcardsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flashcards App',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const FlashcardsScreen(),
    );
  }
}
