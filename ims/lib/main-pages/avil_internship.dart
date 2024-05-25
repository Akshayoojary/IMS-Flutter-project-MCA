import 'package:flutter/material.dart';

class AvilInternshipPage extends StatelessWidget {
  const AvilInternshipPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            child: ListView.builder(
              itemCount: 4, // Replace with your actual count
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    title: Text('Software Engineering Intern'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Join our team to build innovative software solutions.'),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Chip(
                              label: Text('Full Time'),
                              backgroundColor: Colors.blue[100],
                            ),
                            SizedBox(width: 10),
                            Text('Location: Remote'),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
