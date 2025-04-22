import '../../controllers/sign_info_controller.dart';
import '../../core/duifene_sign.dart';

class SignMonitorService {
  final SignInfoController signInfoController;
  final DuifeneSession session;

  SignMonitorService(this.signInfoController, this.session);

  Future<void> updataSignInfo(int selectedIndex) async {
    await signInfoController.getSignInfo(selectedIndex);
  }

  Future<bool> checkSignInStatus(int selectedIndex) async {

    final signInfo = signInfoController.signInfo.value;

    if (signInfo.signedAmount / signInfo.totalAmount >= 0) {
      await session.signIn(signInfo);
      return true;
    }
    return false;
  }
}