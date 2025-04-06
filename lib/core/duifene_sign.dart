import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:html/parser.dart' as html_parser;
import '../models/sign_info.dart';
String extractUserCode(String userLink) {
  final RegExp regex = RegExp(r'code=(\S{32})&');
  final match = regex.firstMatch(userLink);
  if (match != null && match.groupCount > 0) {
    return match.group(1)!;
  }
  throw '链接格式错误';
}

class StudentAmount {
  int signedAmount = 0;
  int totalAmount = 0;
}

class SignInfo {
  String hfSeconds = '';
  String hfCheckType = '';
  String hfCheckInId = '';
  String hfClassId = '';
  String hfCheckCodeKey = '';
  String hfRoomLongitude = '';
  String hfRoomLatitude = '';
  StudentAmount studentAmount = StudentAmount();
}

class CourseInfo {
  late final String courseName;
  late final String courseId;
  late final String classId;
}

class DuifeneSession {
  late final Dio dio;
  late final String studentId;
  List<CourseInfo> courseList = [];
  

  DuifeneSession() {
    dio = Dio();
    dio.options.baseUrl = 'https://www.duifene.com';
    dio.options.followRedirects = false;
    dio.options.validateStatus = (_) => true;
  }
  
  Future<void> login(String userLink) async {
    final userCode = extractUserCode(userLink);
    final String getCookieUrl = '/P.aspx?authtype=1&code=$userCode&state=1';
    
    final response = await dio.get(getCookieUrl);
    final cookies = response.headers['set-cookie'];
    if (cookies != null && cookies.isNotEmpty) {
      final String cookie = cookies.join('; ');
      dio.options.headers['Cookie'] = cookie;
    } else {
      throw '无法获取 Cookie';
    }

    if (response.statusCode == 302) {
      final String locationUrl = response.headers['location']!.first;
      final locationResponse = await dio.get(locationUrl);
      if (locationResponse.statusCode != 200) {
        throw '重定向失败: ${locationResponse.statusCode}';
      }
    } else {
      throw '链接已失效或已过期，请重新获取链接';
    }
    dio.options.headers['Referer'] = 'https://www.duifene.com/_UserCenter/PC/CenterStudent.aspx';
    if (await isLogin()) {
      await getCourseList();
      await getStudentId();
    } else {
      throw '登录失败';
    }
  }

  Future<void> getCourseList() async {
    final courseListUrl = '/_UserCenter/CourseInfo.ashx';
    
    final response = await dio.get(
      courseListUrl,
      queryParameters: {
        'action': 'getstudentcourse',
        'classtypeid': 2,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
    );
    if (response.statusCode == 200) {
      final String data = response.data;

      if (data.contains('msg')) {
        throw '出于某些神秘原因，您当前无法获取课程列表，请稍后再试';
      } else {
        final courses = jsonDecode(data);
        for (var course in courses) {
          CourseInfo courseInfo = CourseInfo();
          courseInfo.courseName = course['CourseName'];
          courseInfo.courseId = course['CourseID'];
          courseInfo.classId = course['TClassID'];
          courseList.add(courseInfo);
        }
      }
    } else {
      throw '获取课程列表失败: ${response.statusCode}';
    }
  }

  Future<void> getStudentId() async {
    final studentIdUrl = '/_UserCenter/MB/index.aspx';
    final response = await dio.get(studentIdUrl);
    if (response.statusCode == 200) {
      final String html = response.data;
      final document = html_parser.parse(html);
      final element = document.getElementById('hidUID');
      if (element != null) {
        studentId = element.attributes['value']!;
      } else {
        throw '获取学生 ID 失败';
      }
    } else {
      throw '获取学生 ID 失败: ${response.statusCode}';
    }
  }

  Future<bool> isLogin() async {
    final response = await dio.get(
      '/AppCode/LoginInfo.ashx',
      data: {
        'Action': 'checklogin',
      },
      options: Options(
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
    );
    if (response.statusCode == 200) {
      final String data = response.data;
      if (data.contains('msg')) {
        final loginInfo = jsonDecode(data);
        if (loginInfo['msg'] == '1') {
          return true;
        } else {
          throw '登录状态异常，请重新登录';
        }
      } else {
        throw '获取登录状态失败: $data';
      }
    } else {
      throw '获取登录状态失败: ${response.statusCode}';
    }
  }

  Future<SignInfo> getSignInfo(int index) async {
    final signInfo = SignInfo();

    await dio.get(
      '/_UserCenter/MB/Module.aspx',
      queryParameters: {
        'data': courseList[index].courseId,
      },
      options: Options(
        headers: {
          'Referer': 'https://www.duifene.com/_UserCenter/MB/index.aspx',
        },
      ),
    );
    await isLogin();

    final response = await dio.get(
      '/_checkin/mb/teachcheckin.aspx?classid=${courseList[index].classId}&temps=0&checktype=1&isrefresh=0&timeinterval=0&roomid=0&match=',
      options: Options(
        headers: {
          'Referer': 'https://www.duifene.com/_UserCenter/MB/index.aspx',
        },
      ),
    );
    if (response.statusCode == 302) {
      final String locationUrl = response.headers['location']!.first;
      print(response.headers);
      final locationResponse = await dio.get(locationUrl);
      if (locationResponse.statusCode != 200) {
        throw '重定向失败: ${locationResponse.statusCode}';
      } else {
        print("重定向");
        final String data = locationResponse.data;
        final document = html_parser.parse(data);
        signInfo.hfSeconds = document.getElementById('HFSeconds')?.attributes['value'] ?? '';
        signInfo.hfCheckType = document.getElementById('HFChecktype')?.attributes['value'] ?? '';
        signInfo.hfCheckInId = document.getElementById('HFCheckInID')?.attributes['value'] ?? '';
        signInfo.hfClassId = document.getElementById('HFClassID')?.attributes['value'] ?? '';
        signInfo.hfCheckCodeKey = document.getElementById('HFCheckCodeKey')?.attributes['value'] ?? '';
        signInfo.hfRoomLongitude = document.getElementById('HFRoomLongitude')?.attributes['value'] ?? '';
        signInfo.hfRoomLatitude = document.getElementById('HFRoomLatitude')?.attributes['value'] ?? '';
      }
    } else if (response.statusCode == 200) {
      final String data = response.data;
      final document = html_parser.parse(data);
      signInfo.hfSeconds = document.getElementById('HFSeconds')?.attributes['value'] ?? '';
      signInfo.hfCheckType = document.getElementById('HFChecktype')?.attributes['value'] ?? '';
      signInfo.hfCheckInId = document.getElementById('HFCheckInID')?.attributes['value'] ?? '';
      signInfo.hfClassId = document.getElementById('HFClassID')?.attributes['value'] ?? '';
      signInfo.hfCheckCodeKey = document.getElementById('HFCheckCodeKey')?.attributes['value'] ?? '';
      signInfo.hfRoomLongitude = document.getElementById('HFRoomLongitude')?.attributes['value'] ?? '';
      signInfo.hfRoomLatitude = document.getElementById('HFRoomLatitude')?.attributes['value'] ?? '';
    } else {
      throw '获取签到信息失败: ${response.statusCode}';
    }
    final studentAmount = await getStudentAmount(signInfo.hfCheckInId);
    signInfo.studentAmount = studentAmount;
    return signInfo;
  }

  Future<StudentAmount> getStudentAmount(String hfCheckInID) async {
    final studentAmount = StudentAmount();
    final response = await dio.get(
      '/_CheckIn/MBCount.ashx',
      queryParameters: {
        'action': 'getcheckintotalbyciid',
        'ciid': hfCheckInID,
        't': 'cking',
      },
      options: Options(
        headers: {
          'Referer': 'https://www.duifene.com/_UserCenter/MB/index.aspx'
        },
      ),
    );
    if (response.statusCode == 200) {
      final String data = response.data;
      final studentAmountInfo = jsonDecode(data);
      studentAmount.totalAmount = studentAmountInfo['TotalNumber'];
      studentAmount.signedAmount = studentAmountInfo['TotalNumber'] - studentAmountInfo['AbsenceNumber'];
    } else {
      throw '获取签到人数失败: ${response.statusCode}';
    }
    return studentAmount;
  }

  Future<void> signIn(NativeSignInfo signInfo) async {
    String hfCheckType = signInfo.hfCheckType;
    if (hfCheckType == '1') {
      await signByCode(signInfo.hfCheckCodeKey);
    } else if (hfCheckType == '2') {
      await signByQr(signInfo.hfCheckInId);
    } else if (hfCheckType == '3') {
      await signByLocation(signInfo.hfRoomLatitude, signInfo.hfRoomLongitude);
    }
  }

  Future<void> signByCode(String hfCheckCodeKey) async {
    final response = await dio.post(
      '/_CheckIn/CheckIn.ashx',
      data: {
        'action': 'studentcheckin',
        'studentid': studentId,
        'checkincode': hfCheckCodeKey,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Referer': 'https://www.duifene.com/_CheckIn/MB/CheckInStudent.aspx?moduleid=16&pasd=',
        },
      ),
    );
    if (response.statusCode == 200) {
      final String data = response.data;
      final result = jsonDecode(data);
      if (result['msg'] != '1') {
        throw '签到码签到失败';
      }
    } else {
      throw '签到码签到失败: ${response.statusCode}';
    }
  }

  Future<void> signByQr(String hfCheckInID) async {
    final response = await dio.get(
      '/_CheckIn/MB/QrCodeCheckOK.aspx',
      queryParameters: {
        'state': hfCheckInID
      }
    );
    if (response.statusCode == 200) {
        final String data = response.data;
        print(data);
        if (!data.contains('DivOK')) {
          throw '二维码签到失败';
        }
    } else {
      throw '二维码签到失败: ${response.statusCode}';
    }
  }

  Future<void> signByLocation(String hfRoomLatitude, String hfRoomLongitude) async {
    final double longitude = double.parse(hfRoomLongitude) + _randomOffset(-0.000089, 0.000089);
    final double latitude = double.parse(hfRoomLatitude) + _randomOffset(-0.000089, 0.000089);

    final response = await dio.post(
      '/_CheckIn/CheckInRoomHandler.ashx',
      data: {
        'action': 'signin',
        'sid': studentId,
        'longitude': longitude.toStringAsFixed(8),
        'latitude': latitude.toStringAsFixed(8),
      },
      options: Options(
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Referer': 'https://www.duifene.com/_CheckIn/MB/CheckInStudent.aspx?moduleid=16&pasd=',
        },
      ),
    );

    if (response.statusCode == 200) {
      final String data = response.data;
      final result = jsonDecode(data);
      if (result['msg'] != 1) {
        throw '定位签到失败';
      }
    } else {
      throw '定位签到失败: ${response.statusCode}';
    }
  }
  
  double _randomOffset(double min, double max) {
    return (min + (max - min) * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000);
  }

  void dispose() {
    dio.close();
  }
}