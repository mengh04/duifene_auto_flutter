import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "services/duifene_service.dart";
import 'pages/login_page.dart';
import 'pages/course_page.dart';
import 'pages/monitor_page.dart';

void main() {
  setupDuifeneService();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '对分易签到助手',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: LoginPage(),
      routes: {
        '/course': (context) => const CoursePage(),
        '/monitor': (context) => const MonitorPage(), // 监控页面
      },
    );
  }
}