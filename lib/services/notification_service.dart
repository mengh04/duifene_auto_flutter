import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  NotificationService._internal() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  }

  Future<void> init() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      windows: WindowsInitializationSettings(
        appName: '签到通知',
        appUserModelId: 'com.example.notification_demo',
        guid: '7bbcd97c-97b5-4595-9598-0778a3bbaadf',
      ),
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification({
    required String title,
    required String body,
    int id = 0,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel_id',
      '默认通知',
      channelDescription: '用于一般性通知',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const windowsDetails = WindowsNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      windows: windowsDetails,
    );

    await _flutterLocalNotificationsPlugin.show(id, title, body, details);
  }
}
