import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:duifene_auto/core/duifene_sign.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Get.find<DuifeneSession>();

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
                Get.toNamed('/monitor', arguments: selectedCourseIndex);
              },
              child: const Text('开始签到'),
            ),
          ],
        ),
      ),
    );
  }
}