import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/duifene_session_provider.dart';

class CoursePage extends ConsumerWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(duifeneSessionProvider);

    final List<DropdownMenuEntry<int>> dropdownMenuEntries = [];
    for (int i = 0; i < session.courseList.length; i++) {
      final courseName = session.courseList[i].courseName;
      dropdownMenuEntries.add(DropdownMenuEntry<int>(
        value: i,
        label: courseName
      ));
    }

    late int? selectedCourseIndex;

    return Scaffold(
      appBar: AppBar(
        title: const Text('课程列表'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '课程列表',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            DropdownMenu(
              onSelected: (value) => selectedCourseIndex = value,
              dropdownMenuEntries: dropdownMenuEntries
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/monitor', arguments: selectedCourseIndex);
              },
              child: const Text('开始签到'),
            ),
          ],
        ),
      ),
    );
  }
}