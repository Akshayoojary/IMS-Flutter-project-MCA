import 'package:flutter/material.dart';
import 'package:ims/Admin-pages/Pages/AttendanceAdminPage.dart';
import 'package:ims/Admin-pages/Pages/TaskAdminPage.dart';
import 'package:ims/Admin-pages/Pages/DocumentAdminPage.dart';
import 'package:ims/Admin-pages/Pages/ResourceAdminPage.dart';
import 'package:ims/Admin-pages/Pages/JobAdmin.dart';
import 'package:ims/Admin-pages/Pages/InternshipAdmin.dart';
import 'package:ims/Admin-pages/Pages/ApplicationsAdminPage.dart'; // Import the ApplicationsAdminPage
import 'package:ims/Admin-pages/Pages/ApplicationsAdminPage.dart';
import 'package:ims/components/top_app_bar.dart'; // Assuming you have this

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  void _navigateToPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(
        title: 'Admin Dashboard',
        isLoggedIn: true, // Assuming the user is logged in
        onLogout: () {
          // Handle logout logic
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0), // Reduced padding to use more space
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: [
            DashboardOption(
              icon: Icons.check_circle,
              label: 'Attendance',
              color: Colors.blue,
              onTap: () => _navigateToPage(AttendanceAdminPage()),
            ),
            DashboardOption(
              icon: Icons.task,
              label: 'Task',
              color: Colors.green,
              onTap: () => _navigateToPage(TaskAdminPage()),
            ),
            DashboardOption(
              icon: Icons.document_scanner,
              label: 'Document',
              color: Colors.orange,
              onTap: () => _navigateToPage(DocumentAdminPage()),
            ),
            DashboardOption(
              icon: Icons.book,
              label: 'Resources',
              color: Colors.purple,
              onTap: () => _navigateToPage(ResourceAdminPage()),
            ),
            DashboardOption(
              icon: Icons.business_center,
              label: 'Jobs',
              color: Colors.red,
              onTap: () => _navigateToPage(JobAdminPage()),
            ),
            DashboardOption(
              icon: Icons.work,
              label: 'Internships',
              color: Colors.teal,
              onTap: () => _navigateToPage(InternshipAdminPage()),
            ),
            DashboardOption(
              icon: Icons.assignment,
              label: 'Applications',
              color: Colors.blueGrey,
              onTap: () => _navigateToPage(ApplicationsAdminPage()),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardOption extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const DashboardOption({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  _DashboardOptionState createState() => _DashboardOptionState();
}

class _DashboardOptionState extends State<DashboardOption> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => _updateHoverState(true),
      onExit: (event) => _updateHoverState(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Card(
          elevation: _isHovered ? 8 : 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: widget.color.withOpacity(_isHovered ? 0.2 : 0.1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  size: 60, // Increased icon size
                  color: widget.color,
                ),
                const SizedBox(height: 20), // Increased space between icon and text
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 20, // Increased text size
                    fontWeight: FontWeight.bold,
                    color: widget.color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateHoverState(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }
}
