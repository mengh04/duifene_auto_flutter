import 'package:duifene_auto/providers/sign_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

class MonitorPage extends ConsumerStatefulWidget {
  const MonitorPage({super.key});

  @override
  ConsumerState<MonitorPage> createState() => _MonitorPageState();
}

class _MonitorPageState extends ConsumerState<MonitorPage> {
  Timer? _timer;
  late int selectedIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as int?;
    selectedIndex = args ?? 0;
    _startPolling();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    // 立即执行一次检查
    _checkSignInStatus();
    // 然后每秒执行一次
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _checkSignInStatus();
    });
  }

  void _stopPolling() {
    _timer?.cancel();
  }

  Future<void> _checkSignInStatus() async {
      ref.read(signInfoProvider.notifier).getSignInfo(selectedIndex);
      final signInfo = ref.read(signInfoProvider);
      if (signInfo.signedAmount / signInfo.totalAmount >= 0.5) {
        _stopPolling(); // 停止轮询
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('签到完成'),
              content: const Text('签到已完成，停止监控。'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('确定'),
                ),
              ],
            ),
          );
        });
      }
      debugPrint('当前课程索引: $selectedIndex');
      debugPrint('当前课程签到类型: ${signInfo.hfChecktype}');
      debugPrint('当前课程签到ID: ${signInfo.hfCheckInId}');
      debugPrint('当前课程剩余秒数: ${signInfo.hfSeconds}');
      debugPrint('当前课程教室纬度: ${signInfo.hfRoomLatitude}');
      debugPrint('当前课程教室经度: ${signInfo.hfRoomLongitude}');
      debugPrint('当前课程签到人数: ${signInfo.signedAmount}');
      debugPrint('当前课程总人数: ${signInfo.totalAmount}');
      debugPrint('签到码: ${signInfo.hfCheckCodeKey}');
  }

  @override
  Widget build(BuildContext context) {
    final signInfo = ref.watch(signInfoProvider); // 自动监听变化
    final notifier = ref.read(signInfoProvider.notifier);
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
                        '课程索引: $selectedIndex',
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
                      _buildInfoRow('签到类型', signInfo.hfChecktype),
                      _buildInfoRow('签到ID', signInfo.hfCheckInId),
                      _buildInfoRow('剩余秒数', signInfo.hfSeconds),
                      _buildInfoRow('教室纬度', signInfo.hfRoomLatitude),
                      _buildInfoRow('教室经度', signInfo.hfRoomLongitude),
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