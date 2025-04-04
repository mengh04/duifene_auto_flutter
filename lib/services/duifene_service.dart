import 'dart:ffi';
import '../core/duifene_sign_bindings.dart';

class DuifeneService {
  static final DuifeneService _instance = DuifeneService._internal();
  factory DuifeneService() => _instance;
  
  late final DynamicLibrary _lib;
  late final DuifeneSign _duifeneSign;

  DuifeneService._internal() {
    _lib = DynamicLibrary.open('duifene_sign_c.dll'); // 统一加载库
    _duifeneSign = DuifeneSign(_lib); // 初始化
  }

  DuifeneSign get duifeneSign => _duifeneSign;
}

// 初始化调用（在main.dart中）
void setupDuifeneService() {
  DuifeneService(); // 触发初始化
}