import 'package:flutter/material.dart';
import 'quiz_page.dart';

void main() {
  runApp(FootballQuizApp());
}

class FootballQuizApp extends StatelessWidget {
  const FootballQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Football Quiz',

      theme: ThemeData(
        primaryColor: Color(0xFF116530),
        scaffoldBackgroundColor: Color(0xFF0B3D2E),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: QuizPage(),
    );
  }
}
