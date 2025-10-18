import 'package:flutter/material.dart';
import 'pages/welcome_page.dart';

void main() {
  runApp(const DayFlowApp());
}

class DayFlowApp extends StatelessWidget {
  const DayFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DayFlow',
      theme: ThemeData.light(),
      home: const WelcomePage(),
    );
  }
}
