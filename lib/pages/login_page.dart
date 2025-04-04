import 'package:duifene_auto/method.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 1. 创建TextEditingController管理输入
  final TextEditingController _linkController = TextEditingController();

  // 6. 释放资源
  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('登录'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _linkController, // 绑定控制器
              decoration: const InputDecoration(
                labelText: '输入登录链接',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url, // 优化键盘类型
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                login(context, _linkController.text); // 调用登录方法
              }, // 绑定登录方法
              child: const Text('登录'),
            ),
          ],
        ),
      ),
    );
  }
}