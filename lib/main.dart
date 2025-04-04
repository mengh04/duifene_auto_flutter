import 'package:duifene_auto/pages/login_page.dart';
import 'package:duifene_auto/pages/choose_course_page.dart';
import 'package:flutter/material.dart';
import 'duifene_service.dart';

void main() {
  // setupDuifeneService();// Initialize the Duifene service
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/choose_course': (context) => ChooseCoursePage(),
        // Add other routes here
      },
    );
  }
}
