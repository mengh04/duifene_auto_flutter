import 'package:duifene_auto/providers/duifene_session_provider.dart';
import 'package:duifene_auto/providers/sign_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/sign_info.dart';
import 'dart:async';

class MonitorPage extends ConsumerStatefulWidget {
  const MonitorPage({super.key});

  @override
  ConsumerState<MonitorPage> createState() => _MonitorPageState();
}

class _MonitorPageState extends ConsumerState<MonitorPage> {
  Timer? _timer;
  late int selectedIndex;
  bool _isChecking = false; // 添加标志位

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as int?;
    selectedIndex = args ?? 0;
    _startPolling();
  }

  @override
  void dispose() {
    _stopPolling();
    super.dispose();
  }

  void _startPolling() {
    if (_timer != null) return; // 防止重复启动计时器
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _checkSignInStatus();
    });
  }

  void _stopPolling() {
    _timer?.cancel();
    _timer = null; // 确保计时器被清除
  }

  Future<void> _checkSignInStatus() async {
    if (_isChecking) return; // 如果正在检查，直接返回
    _isChecking = true; // 设置标志位，表示正在检查

    try {
      ref.read(signInfoProvider.notifier).getSignInfo(selectedIndex);
      final sessionProvider = ref.read(duifeneSessionProvider);
      final NativeSignInfo signInfo = ref.read(signInfoProvider);

      if (signInfo.signedAmount / signInfo.totalAmount >= 0.5) {
        try {
          await sessionProvider.signIn(signInfo);
          showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              padding: const EdgeInsets.all(16.0),
              child: Text('签到成功'),
            ),
          );
          debugPrint("签到成功"); // 添加 await
        } catch (e) {
          showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              padding: const EdgeInsets.all(16.0),
              child: Text('错误: $e'),
            ),
          );
          debugPrint(e.toString());
        }
        _stopPolling(); // 停止轮询

        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   showDialog(
        //     context: context,
        //     builder: (context) => AlertDialog(
        //       title: const Text('签到完成'),
        //       content: const Text('签到已完成，停止监控。'),
        //       actions: [
        //         TextButton(
        //           onPressed: () {
        //             Navigator.pop(context);
        //           },
        //           child: const Text('确定'),
        //         ),
        //       ],
        //     ),
        //   );
        // });
      }
    } finally {
      _isChecking = false; // 检查完成，重置标志位
    }
  }

  @override
  Widget build(BuildContext context) {
    final signInfo = ref.watch(signInfoProvider); // 自动监听变化
    final notifier = ref.read(signInfoProvider.notifier);
    final sessionProvider = ref.read(duifeneSessionProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('签到监控'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _checkSignInStatus,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 课程信息
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        '当前监控课程',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        sessionProvider.courseList[selectedIndex].courseName,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // 签到状态卡片
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        '签到状态',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),      
                      _buildInfoRow('签到类型', () {
                        switch (signInfo.hfCheckType) {
                          case '0':
                            return '未签到';
                          case '1':
                            return '二维码签到';
                          case '2':
                            return '二维码签到';
                          case '3':
                            return '定位签到';
                          default:
                            return '未知签到类型';
                        }
                      }()),
                      _buildInfoRow('签到ID', signInfo.hfCheckInId),
                      if (signInfo.hfCheckType == '1') ...[
                        _buildInfoRow('签到码', signInfo.hfCheckCodeKey),
                      ],
                      _buildInfoRow('已签到人数', signInfo.signedAmount.toString()),
                      _buildInfoRow('未签到人数', (signInfo.totalAmount - signInfo.signedAmount).toString()),

                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // 操作按钮
              ElevatedButton(
                onPressed: () => notifier.getSignInfo(selectedIndex),
                child: const Text('手动刷新'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value.isEmpty ? '无' : value),
          ),
        ],
      ),
    );
  }
}