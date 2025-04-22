import 'package:flutter/material.dart';
import '../../controllers/sign_info_controller.dart';
import '../../core/duifene_sign.dart';

class SignMonitorService {
  final SignInfoController signInfoController;
  final DuifeneSession session;

  SignMonitorService(this.signInfoController, this.session);

  Future<bool> checkSignInStatus(int selectedIndex, BuildContext context) async {
    await signInfoController.getSignInfo(selectedIndex);
    final signInfo = signInfoController.signInfo.value;

    if (signInfo.signedAmount / signInfo.totalAmount >= 0) {
      await session.signIn(signInfo);
      debugPrint('签到成功: ${signInfo.hfCheckInId}');
      return true;
    }
    return false;
  }
}