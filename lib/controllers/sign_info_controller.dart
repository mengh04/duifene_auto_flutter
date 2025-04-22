import 'package:duifene_auto/core/duifene_sign.dart';
import 'package:duifene_auto/models/sign_info.dart';
import 'package:get/get.dart';

class SignInfoController extends GetxController {
  final DuifeneSession session = Get.find<DuifeneSession>();

  var signInfo = NativeSignInfo.empty().obs;

  Future<void> getSignInfo(int index) async {
    final result = await session.getSignInfo(index);
    signInfo.value = NativeSignInfo.from(result);
  }
}