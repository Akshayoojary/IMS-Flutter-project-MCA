import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InternshipAdminPage extends StatefulWidget {
  const InternshipAdminPage({super.key});

  @override
  _InternshipAdminPageState createState() => _InternshipAdminPageState();
}

class _InternshipAdminPageState extends State<InternshipAdminPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  void _saveInternship() {
    final internshipData = {
      'title': titleController.text,
      'description': descriptionController.text,
      'type': typeController.text,
      'location': locationController.text,
      'createdAt': Timestamp.now(),
    };

    FirebaseFirestore.instance.collection('internships').add(internshipData).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Internship added successfully')),
      );
      _clearForm();
    });
  }

  void _clearForm() {
    titleController.clear();
    descriptionController.clear();
    typeController.clear();
    locationController.clear();
  }

  void _deleteInternship(String id) {
    FirebaseFirestore.instance.collection('internships').doc(id).delete();
  }

  void _showEditDialog(DocumentSnapshot document) {
    titleController.text = document['title'] ?? '';
    descriptionController.text = document['description'] ?? '';
    typeController.text = document['type'] ?? '';
    locationController.text = document['location'] ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Internship'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: typeController,
                decoration: InputDecoration(labelText: 'Type'),
              ),
              TextField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('internships').doc(document.id).update({
                  'title': titleController.text,
                  'description': descriptionController.text,
                  'type': typeController.text,
                  'location': locationController.text,
                }).then((_) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Internship updated successfully')),
                  );
                  _clearForm();
                });
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Internship Admin'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: typeController,
              decoration: InputDecoration(
                labelText: 'Type',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveInternship,
              child: Text('Save Internship'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('internships').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error fetching internships.'));
                  }

                  final internships = snapshot.data?.docs ?? [];

                  return ListView.builder(
                    itemCount: internships.length,
                    itemBuilder: (context, index) {
                      final internship = internships[index];
                      final title = internship['title'] ?? 'No title';
                      final description = internship['description'] ?? 'No description';
                      final type = internship['type'] ?? 'No type';
                      final location = internship['location'] ?? 'No location';

                      return Card(
                        child: ListTile(
                          title: Text(title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(description),
                              Text('Type: $type'),
                              Text('Location: $location'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _showEditDialog(internship),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteInternship(internship.id),
                              ),
                            ],
                          ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _clearForm();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add Internship'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                    TextField(
                      controller: typeController,
                      decoration: InputDecoration(labelText: 'Type'),
                    ),
                    TextField(
                      controller: locationController,
                      decoration: InputDecoration(labelText: 'Location'),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      _saveInternship();
                      Navigator.of(context).pop();
                    },
                    child: Text('Save'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
