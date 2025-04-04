import 'dart:ffi';
import 'dart:ffi' as ffi;
import 'package:duifene_auto/core/duifene_sign_bindings.dart';
import 'package:ffi/ffi.dart';
import './duifene_service.dart';

class DuifeneSession {
  final Pointer<Void> _handle;
  
  DuifeneSession() : _handle = DuifeneService().duifeneSign.create_session();
  
  Pointer<Void> get handle => _handle;
  
  void dispose() {
    DuifeneService().duifeneSign.destroy_session(_handle);
  }
  
  Future<void> login(String userLink) async {
    final userLinkPtr = userLink.toNativeUtf8().cast<ffi.Char>();
    DuifeneService().duifeneSign.session_login(_handle, userLinkPtr);
    malloc.free(userLinkPtr);
  }

  int getCourseCount() {
    return DuifeneService().duifeneSign.get_course_count(_handle);
  }

  CourseInfo_C getCourseInfo(int index) {
    final courseInfo = DuifeneService().duifeneSign.get_course_info(_handle, index);
    return courseInfo;
  }

  SignInfo_C getSignInfo(int index) {
    final signInfo = DuifeneService().duifeneSign.get_sign_info(_handle, index);
    return signInfo;
  }

  void doSign(SignInfo_C signInfo) {
    DuifeneService().duifeneSign.do_sign(_handle, signInfo);
  }

}