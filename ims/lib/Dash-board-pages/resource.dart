import 'package:flutter/material.dart';

class ResourcePage extends StatelessWidget {
  const ResourcePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resource'),
      ),
      body: Center(
        child: Text('Resource Page Content'),
      ),
    );
  }
}
