import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/course_page.dart';
import 'pages/monitor_page.dart';
import 'package:get/get.dart';
import 'core/duifene_sign.dart';
import 'controllers/sign_info_controller.dart';

void main() {
  Get.put<DuifeneSession>(DuifeneSession());
  Get.put<SignInfoController>(SignInfoController());
  runApp(const DuifeneAutoApp());
}

class DuifeneAutoApp extends StatelessWidget {
  const DuifeneAutoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '对分易签到助手',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/course', page: () => CoursePage()),
        GetPage(name: '/monitor', page: () => MonitorPage()),
      ],
    );
  }
}