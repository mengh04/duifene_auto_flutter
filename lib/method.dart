import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'duifene_service.dart';
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

void login(BuildContext context, String userLink) {
  // final duifeneService = DuifeneService(); // 获取单例
  // final duifeneSign = duifeneService.duifeneSign; // 获取绑定实例

  // // 创建会话
  // final sessionHandle = duifeneSign.create_session();

  // // 用户链接
  // final userLinkPtr = userLink.toNativeUtf8().cast<ffi.Char>();

  // // 登录
  // duifeneSign.session_login(sessionHandle, userLinkPtr);

  // // 获取课程数量
  // final courseCount = duifeneSign.get_course_count(sessionHandle);
  
  // for (int i = 0; i < courseCount; i++) {
  //   // 获取课程名称
  //   final courseInfo = duifeneSign.get_course_info(sessionHandle, i);
  //   final courseNamePtr = courseInfo.course_name;
  //   final courseName = courseNamePtr.cast<Utf8>().toDartString();
  //   debugPrint('Course $i: $courseName');
  //   duifeneSign.free_course_info(courseInfo); 
  // }
  Navigator.pushReplacementNamed(context, '/choose_course'); // 跳转到选择课程页面
}