import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ims/main-pages/internship_detail_page.dart';

class AvilInternshipPage extends StatelessWidget {
  const AvilInternshipPage({super.key});

  void _navigateToDetail(BuildContext context, String title, String description, String type, String location) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InternshipDetailPage(
          title: title,
          description: description,
          type: type,
          location: location,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Internships'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search internships...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('internships').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error fetching data.'));
                  }

                  final internships = snapshot.data?.docs ?? [];

                  return ListView.builder(
                    itemCount: internships.length,
                    itemBuilder: (context, index) {
                      final internship = internships[index];
                      final title = internship['title'];
                      final description = internship['description'];
                      final type = internship['type'];
                      final location = internship['location'];

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          title: Text(title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(description),
                              SizedBox(height: 5),
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
                            ],
                          ),
                          onTap: () {
                            _navigateToDetail(
                              context,
                              title,
                              description,
                              type,
                              location,
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
