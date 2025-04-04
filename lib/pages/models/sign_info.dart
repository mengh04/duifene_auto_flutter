import 'package:ffi/ffi.dart';
import '../../core/duifene_sign_bindings.dart';

class SignInfo {
  String hfChecktype = '';
  String hfCheckInId = '';
  String hfSeconds = '';
  String hfClassId = '';
  String hfCheckCodeKey = '';
  String hfRoomLatitude = '';
  String hfRoomLongitude = '';
  int signedAmount = 0;
  int totalAmount = 0;

  SignInfo.empty();
  SignInfo.fromC(SignInfo_C signInfo) {
    final hfChecktypePtr = signInfo.hf_checktype;
    final hfCheckInIdPtr = signInfo.hf_check_in_id;
    final hfSecondsPtr = signInfo.hf_seconds;
    final hfClassIdPtr = signInfo.hf_class_id;
    final hfCheckCodeKeyPtr = signInfo.hf_check_code_key;
    final hfRoomLatitudePtr = signInfo.hf_room_latitude;
    final hfRoomLongitudePtr = signInfo.hf_room_longitude;

    hfChecktype = hfChecktypePtr.cast<Utf8>().toDartString();
    hfCheckInId = hfCheckInIdPtr.cast<Utf8>().toDartString();
    hfSeconds = hfSecondsPtr.cast<Utf8>().toDartString();
    hfClassId = hfClassIdPtr.cast<Utf8>().toDartString();
    hfCheckCodeKey = hfCheckCodeKeyPtr.cast<Utf8>().toDartString();
    hfRoomLatitude = hfRoomLatitudePtr.cast<Utf8>().toDartString();
    hfRoomLongitude = hfRoomLongitudePtr.cast<Utf8>().toDartString();

    signedAmount = signInfo.student_amount.signed_amount;
    totalAmount = signInfo.student_amount.total_amount;
  }
}