import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/duifene_session_provider.dart';
class LoginPage extends ConsumerWidget {
  LoginPage({super.key});

  final textfieldController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(duifeneSessionProvider);
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