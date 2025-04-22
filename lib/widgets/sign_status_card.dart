// 📁 monitor/widgets/sign_status_card.dart
import 'package:flutter/material.dart';
import 'package:duifene_auto/models/sign_info.dart';

class SignStatusCard extends StatelessWidget {
  final NativeSignInfo signInfo;

  const SignStatusCard({super.key, required this.signInfo});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('签到状态',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildInfoRow('签到类型', _getCheckType(signInfo.hfCheckType)),
            _buildInfoRow('签到ID', signInfo.hfCheckInId),
            if (signInfo.hfCheckType == '1')
              _buildInfoRow('签到码', signInfo.hfCheckCodeKey),
            _buildInfoRow('已签到人数', signInfo.signedAmount.toString()),
            _buildInfoRow('未签到人数',
                (signInfo.totalAmount - signInfo.signedAmount).toString()),
          ],
        ),
      ),
    );
  }

  String _getCheckType(String type) {
    switch (type) {
      case '0':
        return '未签到';
      case '1':
      case '2':
        return '二维码签到';
      case '3':
        return '定位签到';
      default:
        return '未检测到签到';
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child:
                Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
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
