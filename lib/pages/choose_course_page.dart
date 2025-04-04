import 'package:flutter/material.dart';

class ChooseCoursePage extends StatefulWidget {
  @override
  _ChooseCoursePageState createState() => _ChooseCoursePageState();
}

class _ChooseCoursePageState extends State<ChooseCoursePage> {
  final List<String> courses = ['Math', 'Science', 'History', 'Art', 'Music'];
  String? selectedCourse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose a Course'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<String>(
              value: selectedCourse,
              hint: Text('Select a course'),
              isExpanded: true,
              items: courses.map((course) {
                return DropdownMenuItem<String>(
                  value: course,
                  child: Text(course),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCourse = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedCourse == null
                  ? null
                  : () {
                      // Handle the confirmation action
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('You selected: $selectedCourse'),
                        ),
                      );
                    },
              child: Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}