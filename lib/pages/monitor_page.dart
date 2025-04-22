import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:duifene_auto/core/duifene_sign.dart';
import 'package:duifene_auto/controllers/sign_info_controller.dart';
import 'package:duifene_auto/widgets/sign_status_card.dart';
import 'package:duifene_auto/controllers/sign_monitor_controller.dart';

class MonitorPage extends StatefulWidget {
  const MonitorPage({super.key});

  @override
  State<MonitorPage> createState() => _MonitorPageState();
}

class _MonitorPageState extends State<MonitorPage> {
  late final signInfoController = Get.find<SignInfoController>();
  late final signMonitorController = Get.find<SignMonitorController>();
  late final session = Get.find<DuifeneSession>();
  late final int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = Get.arguments as int? ?? 0;
    signMonitorController.startMonitoring(selectedIndex);
  }

  @override
  void dispose() {
    signMonitorController.stopMonitoring(); // ✅ 页面退出时停止监控
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final course = session.courseList[selectedIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('签到监控'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            final signInfo = signInfoController.signInfo.value;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text('当前监控课程',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(course.courseName,
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SignStatusCard(signInfo: signInfo),
              ],
            );
          }),
        ),
      ),
    );
  }
}
