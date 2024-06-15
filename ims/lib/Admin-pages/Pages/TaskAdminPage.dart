import 'package:flutter/material.dart';

class TaskAdminPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _taskController = TextEditingController();
  final _deadlineController = TextEditingController();

  TaskAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _taskController,
              decoration: InputDecoration(labelText: 'Task'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a task';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _deadlineController,
              decoration: InputDecoration(labelText: 'Deadline'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a deadline';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Save data to the backend
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Processing Data')),
                  );
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
