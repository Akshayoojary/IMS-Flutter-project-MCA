import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JobDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final String type;
  final String location;

  const JobDetailPage({
    Key? key,
    required this.title,
    required this.description,
    required this.type,
    required this.location,
  }) : super(key: key);

  Future<void> _applyForJob(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be logged in to apply.')),
      );
      return;
    }

    final userProfile = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (!userProfile.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User profile not found.')),
      );
      return;
    }

    final applicationData = {
      'userId': user.uid,
      'userName': userProfile['name'],
      'userEmail': user.email,
      'jobTitle': title,
      'jobDescription': description,
      'jobType': type,
      'jobLocation': location,
      'appliedAt': Timestamp.now(),
    };

    await FirebaseFirestore.instance.collection('job_applications').add(applicationData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Application submitted successfully.')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Chip(
                  label: Text(type),
                  backgroundColor: Colors.blue[100],
                ),
                SizedBox(width: 10),
                Text('Location: $location'),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _applyForJob(context),
              child: Text('Apply Now'),
            ),
          ],
        ),
      ),
    );
  }
}
