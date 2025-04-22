import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import '../controllers/sign_monitor_controller.dart';

class MonitorForegroundTask extends TaskHandler {
  late final SignMonitorController controller;
  late int selectedIndex;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    controller = Get.find<SignMonitorController>();
    selectedIndex = int.tryParse(await FlutterForegroundTask.getData<String>(key: 'selectedIndex') ?? '') ?? 0;
  }

  @override
  Future<void> onRepeatEvent(DateTime timestamp) async {
    await controller.checkSignInStatus(selectedIndex);
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
  }

  @override
  void onNotificationButtonPressed(String id) {}

  @override
  void onNotificationPressed() {}
}
