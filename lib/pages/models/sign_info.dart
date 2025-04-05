import '../../core/duifene_sign.dart';
class NativeSignInfo {
  String hfChecktype = '';
  String hfCheckInId = '';
  String hfSeconds = '';
  String hfClassId = '';
  String hfCheckCodeKey = '';
  String hfRoomLatitude = '';
  String hfRoomLongitude = '';
  int signedAmount = 0;
  int totalAmount = 0;

  NativeSignInfo.empty();
  NativeSignInfo.from(SignInfo signInfo) {
    hfChecktype = signInfo.hfCheckType;
    hfCheckInId = signInfo.hfCheckInId;
    hfSeconds = signInfo.hfSeconds;
    hfClassId = signInfo.hfClassId;
    hfCheckCodeKey = signInfo.hfCheckCodeKey;
    hfRoomLatitude = signInfo.hfRoomLatitude;
    hfRoomLongitude = signInfo.hfRoomLongitude;

    signedAmount = signInfo.studentAmount.signedAmount;
    totalAmount = signInfo.studentAmount.totalAmount;
  }
}