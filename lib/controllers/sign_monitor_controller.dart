// controllers/sign_monitor_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:duifene_auto/core/duifene_sign.dart';
import 'package:duifene_auto/services/sign_monitor_service.dart';
import 'package:duifene_auto/controllers/sign_info_controller.dart';
import 'package:duifene_auto/services/notification_service.dart';

class SignMonitorController extends GetxController {
  final SignInfoController signInfoController;
  final DuifeneSession session;

  late final SignMonitorService _signMonitorService;


  var checkedId = ''.obs;

  SignMonitorController(this.signInfoController, this.session);

  @override
  void onInit() {
    super.onInit();
    _signMonitorService = SignMonitorService(signInfoController, session);
  }

  // 检查签到状态
  Future<bool> checkSignInStatus(int selectedIndex) async {
    await _signMonitorService.updataSignInfo(selectedIndex);
    
    final currentId = signInfoController.signInfo.value.hfCheckInId;

    if (checkedId.value == currentId) {
      return false;
    }
    if (currentId.isEmpty) {
      checkedId.value = currentId;
      return false;
    }

    checkedId.value = currentId;
    try {
      final success = await _signMonitorService.checkSignInStatus(
        selectedIndex
      );
      if (success) {
        // 显示通知
        NotificationService().showNotification(
          title: '签到成功',
          body: '签到成功，课程：${session.courseList[selectedIndex].courseName}',
        );
      }
      return success;
    } catch (e) {
      debugPrint('签到检查错误: $e');
      return false;
    }
  }

  bool monitoring = true;

  Future<void> startMonitoring(int selectedIndex) async {
    monitoring = true;
    while (monitoring) {
      await Future.delayed(const Duration(seconds: 1));
      debugPrint(selectedIndex.toString());
      await checkSignInStatus(selectedIndex);
    }
  }

  void stopMonitoring() {
    monitoring = false; // Add logic to stop monitoring
    debugPrint('停止监控');
  }
}
