import 'package:flutter/material.dart';
import '../core/duifene_sign.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final textfieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    final session = Get.find<DuifeneSession>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('对分易签到助手'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '对分易签到助手',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: textfieldController,
                decoration: const InputDecoration(
                  labelText: '请输入登录链接',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                await session.login(textfieldController.text);
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/course');
                }
              },
              child: const Text('登录'),
            ),
          ]
        )

        // child: 
      ),
    );
  }
}