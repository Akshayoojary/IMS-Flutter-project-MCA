import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicationsAdminPage extends StatefulWidget {
  const ApplicationsAdminPage({Key? key}) : super(key: key);

  @override
  _ApplicationsAdminPageState createState() => _ApplicationsAdminPageState();
}

class _ApplicationsAdminPageState extends State<ApplicationsAdminPage> {
  Stream<QuerySnapshot> _jobApplicationsStream =
      FirebaseFirestore.instance.collection('job_applications').snapshots();
  Stream<QuerySnapshot> _internshipApplicationsStream =
      FirebaseFirestore.instance.collection('internship_applications').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Applications Admin'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSectionTitle('Job Applications'),
            _buildApplicationsList(_jobApplicationsStream, 'Job'),
            _buildSectionTitle('Internship Applications'),
            _buildApplicationsList(_internshipApplicationsStream, 'Internship'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildApplicationsList(Stream<QuerySnapshot> stream, String applicationType) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error fetching $applicationType applications.'));
        }

        final applications = snapshot.data?.docs ?? [];

        if (applications.isEmpty) {
          return Center(child: Text('No $applicationType applications found.'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: applications.length,
          itemBuilder: (context, index) {
            final application = applications[index];
            final title = application['title'] ?? 'No title';
            final description = application['description'] ?? 'No description';
            final applicantName = application['applicantName'] ?? 'Unknown';
            final applicationDate = (application['applicationDate'] as Timestamp?)?.toDate() ?? DateTime.now();

            return Card(
              child: ListTile(
                title: Text(title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(description),
                    Text('Applicant: $applicantName'),
                    Text('Date: ${applicationDate.toLocal()}'.split(' ')[0]), // Displaying date part only
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
