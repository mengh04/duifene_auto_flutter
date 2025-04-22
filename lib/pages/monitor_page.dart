import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import '../../core/duifene_sign.dart';
import '../../controllers/sign_info_controller.dart';
import '../services/sign_monitor_service.dart';
import '../widgets/sign_status_card.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MonitorPage extends StatefulWidget {
  const MonitorPage({super.key});
  @override
  State<MonitorPage> createState() => _MonitorPageState();
}

class _MonitorPageState extends State<MonitorPage> {
  bool _isPolling = false; // 控制轮询状态
  late int selectedIndex;
  final signInfoController = Get.find<SignInfoController>();
  final session = Get.find<DuifeneSession>();
  late final SignMonitorService _signMonitorService;
  String checkedId = 'None';
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _signMonitorService = SignMonitorService(signInfoController, session);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializeNotifications();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as int?;
    selectedIndex = args ?? 0;
    _startPolling();
  }

  @override
  void dispose() {
    _stopPolling();
    super.dispose();
  }

  void _initializeNotifications() async {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      // android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      // iOS: IOSInitializationSettings(),
      // macOS: MacOSInitializationSettings(),
      windows: WindowsInitializationSettings(
        appName: 'Notification Demo',
        appUserModelId: 'com.example.notification_demo',
        guid: '7bbcd97c-97b5-4595-9598-0778a3bbaadf',
      ),
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // 启动轮询
  void _startPolling() {
    if (_isPolling) return;
    _isPolling = true;
    _poll();
  }

  void showNotification(String title, String body) {
    const notificationDetails = NotificationDetails(
      windows: WindowsNotificationDetails(
        // Windows 上通知没有太多选项，只要这个就行
        // 可加 icon/image/音效等，但最基础就这样
      ),
    );
    flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  // 停止轮询
  void _stopPolling() {
    _isPolling = false;
  }

  // 异步轮询
  void _poll() async {
    if (!_isPolling) return;

    // 执行签到检查
    final success = await _checkSignInStatus();
    if (success) {
      checkedId = signInfoController.signInfo.value.hfCheckInId;
      debugPrint('签到成功: ${signInfoController.signInfo.value.hfCheckInId}');
      showNotification('签到成功', '签到ID: ${signInfoController.signInfo.value.hfCheckInId}');
      _stopPolling();  // 如果签到成功，停止轮询
    } else {
      // 使用 Future.delayed 替代递归调用，避免栈溢出
      if (_isPolling) {
        await Future.delayed(const Duration(seconds: 1));
        _poll();  // 继续下次轮询
      }
    }
  }

  // 检查签到状态
  Future<bool> _checkSignInStatus() async {
    if (checkedId == signInfoController.signInfo.value.hfCheckInId) {
      return false;  // 如果签到ID没有变化，则不进行签到
    }
    try {
      final success = await _signMonitorService.checkSignInStatus(selectedIndex, context);
      return success;
    } catch (e) {
      debugPrint('$e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final course = session.courseList[selectedIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('签到监控'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _checkSignInStatus,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            final signInfo = signInfoController.signInfo.value;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 课程卡片
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

                // 签到状态卡片组件
                SignStatusCard(signInfo: signInfo),

                const SizedBox(height: 20),

                // 手动刷新按钮
                ElevatedButton(
                  onPressed: () => signInfoController.getSignInfo(selectedIndex),
                  child: const Text('手动刷新'),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
